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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import Kingfisher
import UIKit

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class TryOnImpl: TryOn {
        @injected private var api: ApiService
        @injected private var history: Sdk.Core.History
        @injected private var session: Sdk.Core.Session
        @injected private var subscription: Sdk.Core.Subscription

        var sessionResults = DataProvider<TryOnResult>()
        private let jpegCompressionQuality: CGFloat = 65
        private let generationStatusTime: TimeInterval = 3
        private var terminated: Bool = false
        private let fakeGeneration = false

        init() {
            history.generated.onUpdate.subscribe(with: self) { [unowned self] in
                sessionResults.items.removeAll(where: { result in
                    !history.generated.items.contains(where: { $0.id == result.image.id })
                })
            }
        }

        func abortAll() {
            terminated = true
        }

        @MainActor func tryOn(_ source: ImageSource,
                              with products: Aiuta.Products?,
                              status callback: @escaping (TryOnStatus) -> Void) async throws -> TryOnStats {
            guard let products, !products.isEmpty else {
                throw TryOnError.error(.internalSdkError)
            }

            terminated = false
            let stats = TryOnStatsImpl()

            let imageId: String
            var uploadedImage: Aiuta.Image?
            if let id = source.knownRemoteId {
                uploadedImage = nil
                imageId = id
                Task {
                    let isTouched = (try? await history.touchUploaded(with: id)) ?? false
                    if !isTouched { uploadedImage = source as? Aiuta.Image }
                }
            } else {
                callback(.uploadingImage)
                stats.uploadStarted()
                let image = try await upload(source, status: callback)
                stats.uploadFinished()
                uploadedImage = image
                imageId = image.id
            }

            if terminated {
                throw TryOnError.terminate
            }

            callback(.scanningBody)

            let start: Aiuta.TryOnStart

            if fakeGeneration {
                start = .init(operationId: "fake", details: nil, errors: [])
            } else {
                do {
                    start = try await api.request(Aiuta.TryOnStart.Post(uploadedImageId: imageId, skuIds: products.ids))
                } catch {
                    throw TryOnError.error(.startOperationFailed, underlying: error)
                }
            }

            var delays = subscription.operationDelays
            var isGenerating = false
            stats.tryOnStarted()

            repeat {
                if terminated {
                    throw TryOnError.terminate
                }

                guard let delay = delays.next() else {
                    throw TryOnError.error(.operationTimeout)
                }

                if !isGenerating, stats.currentDuration > generationStatusTime {
                    callback(.generatingOutfit)
                    isGenerating = true
                }

                await asleep(delay)

                let operation: Aiuta.TryOnOperation
                do {
                    if fakeGeneration {
                        await asleep(.twoSeconds)
                        operation = .init(id: start.operationId, status: .success, error: nil,
                                          generatedImages: [.init(id: imageId, url: uploadedImage?.url ?? "", ownerType: .aiuta)])
                    } else {
                        operation = try await api.request(Aiuta.TryOnOperation.Get(operationId: start.operationId))
                    }
                } catch {
                    throw TryOnError.error(.requestOperationFailed, underlying: error)
                }

                switch operation.status {
                    case .created, .inProgress:
                        break
                    case .success:
                        stats.tryOnFinished()
                        stats.downloadStarted()
                        try await success(operation, with: products, uploadedImage: uploadedImage)
                        stats.downloadFinished()
                        return stats
                    case .aborted:
                        throw TryOnError.abort
                    case .failed, .cancelled, .unknown:
                        throw TryOnError.error(.operationFailed, underlying: operation)
                }
            } while true
        }

        @MainActor func success(_ operation: Aiuta.TryOnOperation,
                                with products: Aiuta.Products,
                                uploadedImage: Aiuta.Image?) async throws {
            guard !operation.generatedImages.isEmpty else {
                throw TryOnError.error(.operationEmptyResults)
            }

            if terminated {
                throw TryOnError.terminate
            }

            if let uploadedImage { Task { try? await history.addUploaded(uploadedImage) } }
            Task { try? await history.addGenerated(operation.generatedImages, for: products) }

            do {
                _ = try await operation.generatedImages.concurrentMap { generatedImage in
                    try await generatedImage.prefetch(.hiResImage, breadcrumbs: Breadcrumbs())
                }
            } catch {
                throw TryOnError.error(.downloadResultFailed, underlying: error)
            }

            sessionResults.items.insert(contentsOf: operation.generatedImages.map { gen in
                .init(id: gen.url, image: gen, products: products)
            }, at: 0)
        }

        @MainActor func upload(_ source: ImageSource, status callback: @escaping (TryOnStatus) -> Void) async throws -> Aiuta.Image {
            guard let image = try? await source.fetch(breadcrumbs: Breadcrumbs()) else {
                throw TryOnError.error(.preparePhotoFailed)
            }

            guard let imageData = await compress(image) else {
                throw TryOnError.error(.preparePhotoFailed)
            }

            do {
                let uploadedImage: Aiuta.Image = try await api.request(Aiuta.Image.Post(imageData: imageData))
                callback(.imageUploaded)
                return uploadedImage
            } catch {
                throw TryOnError.error(.uploadPhotoFailed, underlying: error)
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
}

extension Sdk.Core {
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

        var currentDuration: TimeInterval { .now - tryOnStart }
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
}
