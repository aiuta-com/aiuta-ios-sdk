// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@_spi(Aiuta) import AiutaKit
import Kingfisher
import UIKit

@available(iOS 13.0.0, *)
final class TryOnModelImpl: TryOnModel {
    @injected private var api: ApiService
    @injected private var history: HistoryModel
    @injected private var session: SessionModel
    @injected private var tracker: AnalyticTracker

    var sessionResults = DataProvider<TryOnResult>()
    private let jpegCompressionQuality: CGFloat = 65

    init() {
        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            sessionResults.items.removeAll(where: { result in
                !history.generated.items.contains(where: { $0.id == result.image.id })
            })
        }
    }

    @MainActor func tryOn(_ source: ImageSource,
                          with sku: Aiuta.Product?,
                          status callback: @escaping (TryOnStatus) -> Void) async throws {
        guard let sku else { throw TryOnError.noSku }

        tracker.track(.tryOn(.generate(sku: sku)))

        let imageId: String
        let uploadedImage: Aiuta.Image?
        if let id = source.knownRemoteId {
            Task { try? await history.touchUploaded(with: id) }
            uploadedImage = nil
            imageId = id
        } else {
            callback(.uploadingImage)
            do {
                let image = try await upload(source)
                uploadedImage = image
                imageId = image.id
            } catch {
                tracker.track(.tryOn(.error(sku: sku, type: .uploadFailed)))
                throw error
            }
        }

        let startTime = Date()
        tracker.track(.tryOn(.generate(sku: sku)))
        callback(.scanningBody)

        let start: Aiuta.TryOnStart
        do {
            start = try await api.request(Aiuta.TryOnStart.Post(uploadedImageId: imageId, skuId: sku.skuId, skuCatalogName: sku.skuCatalog))
        } catch {
            tracker.track(.tryOn(.error(sku: sku, type: .tryOnStartFailed)))
            throw error
        }

        var delays: [TimeInterval] = .init(repeating: 0.5, count: 12) + [1, 1, 2]
        var isGenerating = false
        var checkCount = 0

        repeat {
            if checkCount > 2, !isGenerating {
                isGenerating = true
                callback(.generatingOutfit)
            }

            await asleep(.custom(delays.popLast() ?? 3))

            guard let operation: Aiuta.TryOnOperation = try? await api.request(Aiuta.TryOnOperation.Get(operationId: start.operationId)) else { continue }

            switch operation.status {
                case .created, .inProgress:
                    break
                case .success:
                    try await success(operation, with: sku, uploadedImage: uploadedImage, from: startTime)
                    return
                case .aborted:
                    tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationAborted)))
                    throw TryOnError.tryOnAborted
                case .failed, .cancelled, .unknown:
                    tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationFailed)))
                    throw TryOnError.tryOnFailed
            }

            checkCount += 1
        } while true
    }

    @MainActor func success(_ operation: Aiuta.TryOnOperation,
                            with sku: Aiuta.Product,
                            uploadedImage: Aiuta.Image?,
                            from startTime: Date) async throws {
        guard !operation.generatedImages.isEmpty else {
            tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationFailed)))
            throw TryOnError.emptyResults
        }

        let duration = -startTime.timeIntervalSinceNow
        tracker.track(.tryOn(.finish(sku: sku, time: duration)))

        if let uploadedImage { Task { try? await history.addUploaded(uploadedImage) } }
        Task { try? await history.addGenerated(operation.generatedImages) }

        _ = try await operation.generatedImages.concurrentMap { generatedImage in
            try await generatedImage.prefetch(.hiResImage, breadcrumbs: Breadcrumbs())
        }

        sessionResults.items.insert(contentsOf: operation.generatedImages.map { gen in
            .init(id: gen.url, image: gen, sku: sku)
        }, at: 0)
    }

    @MainActor func upload(_ source: ImageSource) async throws -> Aiuta.Image {
        guard let imageData = await compress(try await source.fetch(breadcrumbs: Breadcrumbs())) else {
            throw TryOnError.prepareImageFailed
        }
        let uploadedImage: Aiuta.Image = try await api.request(Aiuta.Image.Post(imageData: imageData))
        session.track(.tryOn(event: .photoUploaded, message: nil, page: .loading, product: session.activeSku))
        return uploadedImage
    }

    @MainActor func compress(_ image: UIImage) async -> Data? {
        await withCheckedContinuation { continuation in
            dispatch(.user) { [jpegCompressionQuality] in
                let imageData = image.jpegData(compressionQuality: jpegCompressionQuality)
                continuation.resume(returning: imageData)
            }
        }
    }
}
