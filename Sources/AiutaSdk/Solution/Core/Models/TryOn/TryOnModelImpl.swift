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
    @injected private var subscription: SubscriptionModel
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
                          status callback: @escaping (TryOnStatus) -> Void) async throws -> TryOnStats {
        guard let sku else {
            tracker.track(.error(error: .noActiveSku, product: sku))
            throw TryOnError.noSku
        }
        let stats = TryOnStatsImpl()

        let imageId: String
        let uploadedImage: Aiuta.Image?
        if let id = source.knownRemoteId {
            Task { try? await history.touchUploaded(with: id) }
            uploadedImage = nil
            imageId = id
        } else {
            callback(.uploadingImage)
            stats.uploadStarted()
            let image = try await upload(source, with: sku)
            stats.uploadFinished()
            uploadedImage = image
            imageId = image.id
        }

        callback(.scanningBody)

        let start: Aiuta.TryOnStart
        stats.tryOnStarted()
        do {
            start = try await api.request(Aiuta.TryOnStart.Post(uploadedImageId: imageId, skuId: sku.skuId, skuCatalogName: sku.skuCatalog))
        } catch {
            tracker.track(.error(error: .startOperationFailed, product: sku))
            throw error
        }

        var delays = subscription.operationDelays
        var isGenerating = false
        var checkCount = 0

        repeat {
            guard let delay = delays.next() else {
                tracker.track(.error(error: .operationTimeout, product: sku))
                throw TryOnError.tryOnTimeout
            }

            if checkCount > 2, !isGenerating {
                isGenerating = true
                callback(.generatingOutfit)
            }

            await asleep(delay)

            do {
                let operation: Aiuta.TryOnOperation = try await api.request(Aiuta.TryOnOperation.Get(operationId: start.operationId))

                switch operation.status {
                    case .created, .inProgress:
                        break
                    case .success:
                        stats.tryOnFinished()
                        stats.downloadStarted()
                        try await success(operation, with: sku, uploadedImage: uploadedImage)
                        stats.downloadFinished()
                        return stats
                    case .aborted:
                        tracker.track(.error(error: .operationAborted, product: sku))
                        throw TryOnError.tryOnAborted
                    case .failed, .cancelled, .unknown:
                        tracker.track(.error(error: .operationFailed, product: sku))
                        throw TryOnError.tryOnFailed
                }

            } catch {
                tracker.track(.error(error: .requestOperationFailed, product: sku))
                throw error
            }

            checkCount += 1
        } while true
    }

    @MainActor func success(_ operation: Aiuta.TryOnOperation,
                            with sku: Aiuta.Product,
                            uploadedImage: Aiuta.Image?) async throws {
        guard !operation.generatedImages.isEmpty else {
            tracker.track(.error(error: .operationEmptyResults, product: sku))
            throw TryOnError.emptyResults
        }

        if let uploadedImage { Task { try? await history.addUploaded(uploadedImage) } }
        Task { try? await history.addGenerated(operation.generatedImages) }

        do {
            _ = try await operation.generatedImages.concurrentMap { generatedImage in
                try await generatedImage.prefetch(.hiResImage, breadcrumbs: Breadcrumbs())
            }
        } catch {
            tracker.track(.error(error: .downloadResultFailed, product: sku))
            throw error
        }

        sessionResults.items.insert(contentsOf: operation.generatedImages.map { gen in
            .init(id: gen.url, image: gen, sku: sku)
        }, at: 0)
    }

    @MainActor func upload(_ source: ImageSource, with sku: Aiuta.Product?) async throws -> Aiuta.Image {
        guard let image = try? await source.fetch(breadcrumbs: Breadcrumbs()) else {
            tracker.track(.error(error: .preparePhotoFailed, product: sku))
            throw TryOnError.prepareImageFailed
        }
        guard let imageData = await compress(image) else {
            tracker.track(.error(error: .preparePhotoFailed, product: sku))
            throw TryOnError.prepareImageFailed
        }
        do {
            let uploadedImage: Aiuta.Image = try await api.request(Aiuta.Image.Post(imageData: imageData))
            session.track(.tryOn(event: .photoUploaded, message: nil, page: .loading, product: session.activeSku))
            return uploadedImage
        } catch {
            tracker.track(.error(error: .uploadPhotoFailed, product: sku))
            throw error
        }
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

final class TryOnStatsImpl: TryOnStats {
    private var uploadStart: TimeInterval = .now
    private var uploadFinish: TimeInterval = .now

    func uploadStarted() {
        uploadStart = .now
    }

    func uploadFinished() {
        uploadFinish = .now
    }

    var uploadDuration: TimeInterval { uploadFinish - uploadStart }

    private var tryOnStart: TimeInterval = .now
    private var tryOnFinish: TimeInterval = .now

    func tryOnStarted() {
        tryOnStart = .now
    }

    func tryOnFinished() {
        tryOnFinish = .now
    }

    var tryOnDuration: TimeInterval { tryOnFinish - tryOnStart }

    private var downloadStart: TimeInterval = .now
    private var downloadFinish: TimeInterval = .now

    func downloadStarted() {
        downloadStart = .now
    }

    func downloadFinished() {
        downloadFinish = .now
    }

    var downloadDuration: TimeInterval { downloadFinish - downloadStart }
}
