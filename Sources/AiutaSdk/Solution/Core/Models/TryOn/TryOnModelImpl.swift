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

    init() {
        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            sessionResults.items.removeAll(where: { result in
                !history.generated.items.contains(where: { $0.url == result.image.url })
            })
        }
    }

    @MainActor func tryOn(_ source: ImageSource, with sku: Aiuta.Product?, status callback: @escaping (TryOnStatus) -> Void) async throws {
        guard let sku else { throw TryOnError.noSku }

        tracker.track(.tryOn(.start(origin: .tryOnButton, sku: sku, photosCount: 1)))

        let imageId: String
        if let id = source.knownRemoteId {
            history.touchUploaded(with: id)
            imageId = id
        } else {
            callback(.uploadingImage)
            do {
                imageId = try await upload(source)
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

            guard operation.status != .failed else {
                tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationFailed)))
                throw TryOnError.tryOnFailed
            }

            if operation.status == .success {
                guard !operation.generatedImages.isEmpty else {
                    tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationFailed)))
                    throw TryOnError.tryOnFailed
                }

                let duration = -startTime.timeIntervalSinceNow
                tracker.track(.tryOn(.finish(sku: sku, time: duration)))

                history.addGenerated(operation.generatedImages)

                _ = try await operation.generatedImages.concurrentMap { generatedImage in
                    try await generatedImage.prefetch(.hiResImage, breadcrumbs: Breadcrumbs())
                }

                sessionResults.items.insert(contentsOf: operation.generatedImages.map { gen in
                    .init(id: gen.url, image: gen, sku: sku)
                }, at: 0)
                return
            }

            checkCount += 1
        } while true
    }

    @MainActor func upload(_ source: ImageSource) async throws -> String {
        guard let imageData = await compress(try await source.fetch(breadcrumbs: Breadcrumbs())) else {
            throw TryOnError.prepareImageFailed
        }
        let uploadedImage: Aiuta.UploadedImage = try await api.request(Aiuta.UploadedImage.Post(imageData: imageData))
        history.addUploaded(uploadedImage)
        session.delegate?.aiuta(eventOccurred: .tryOn(event: .photoUploaded))
        return uploadedImage.id
    }

    @MainActor func compress(_ image: UIImage) async -> Data? {
        await withCheckedContinuation { continuation in
            dispatch(.user) {
                let imageData = image.jpegData(compressionQuality: 65)
                continuation.resume(returning: imageData)
            }
        }
    }
}
