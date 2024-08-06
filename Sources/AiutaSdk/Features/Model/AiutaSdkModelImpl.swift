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
import Resolver
import UIKit

@available(iOS 13.0, *)
final class AiutaSdkModelImpl: AiutaSdkModel {
    @injected private var api: ApiService
    @injected private var config: Aiuta.Configuration
    @injected private var tracker: AnalyticTracker

    let onChangeState: Signal<Aiuta.SessionState> = Signal<Aiuta.SessionState>(retainLastData: true)
    let onChangeSku: Signal<Aiuta.SkuInfo> = Signal<Aiuta.SkuInfo>(retainLastData: true)
    let onChangeResults: Signal<([Aiuta.GeneratedImage], Aiuta.SkuInfo)> = Signal<([Aiuta.GeneratedImage], Aiuta.SkuInfo)>()
    var onChangeUploads: Signal<[Aiuta.UploadedImage]> = Signal<[Aiuta.UploadedImage]>()
    let onStatus: Signal<String> = Signal<String>()
    let onError: Signal<String> = Signal<String>()

    var tryOnSku: Aiuta.SkuInfo? {
        didSet {
            guard oldValue != tryOnSku, let tryOnSku else { return }
            moreToTryOn = allSku.filter { $0 != tryOnSku }
            dispatch(.mainAsync) { [self] in
                onChangeSku.fire(tryOnSku)
                state = .photoSelecting
            }
        }
    }

    var allSku: [Aiuta.SkuInfo] = []
    var moreToTryOn: [Aiuta.SkuInfo] = []

    var state: Aiuta.SessionState = .initial {
        didSet {
            guard oldValue < state || state <= .photoSelecting else { return }
            onChangeState.fire(state)
        }
    }

    var generationResults: [Aiuta.SessionResult] = [] {
        didSet {
            guard oldValue != generationResults, let tryOnSku else { return }
            onChangeResults.fire(([], tryOnSku))
        }
    }

    weak var delegate: AiutaSdkDelegate?

    @defaults(key: "generationHistory", defaultValue: [])
    var generationHistory: [Aiuta.GeneratedImage]

    var onChangeHistory: Signal<[Aiuta.GeneratedImage]> {
        $generationHistory.onValueChanged
    }

    @defaults(key: "uploadsHistory", defaultValue: [])
    var uploadsHistory: [[Aiuta.UploadedImage]]

    private var sessionUuid = UUID()
    private let downsampler = DownsamplingImageProcessor(size: .init(square: 1500))

    func eraseHistoryIfNeeded() {
        if !config.behavior.isHistoryAvailable {
            generationHistory = []
        }
    }

    func startSession(_ session: Aiuta.TryOnSession) {
        delegate = session.delegate
        allSku = session.moreToTryOn + [session.tryOnSku]
        tryOnSku = session.tryOnSku
        state = .photoSelecting
        generationResults = []
        sessionUuid = UUID()
        tracker.track(.session(.start(sku: session.tryOnSku, relatedCount: moreToTryOn.count)))
    }

    func preloadImage(_ url: String?) {
        Task { await preload(url) }
    }

    func startTryOn(_ input: Aiuta.Inputs, origin: AnalyticEvent.TryOn.Origin) {
        Task {
            await startTryOn(input, uuid: sessionUuid, origin: origin)
        }
    }

    func reportError(_ text: String = L.tryAgain, forSku sku: Aiuta.SkuInfo, uuid: UUID) {
        guard sku == tryOnSku, uuid == sessionUuid else { return }
        onError.fire(text)
    }

    func addResults(_ generatedImages: [Aiuta.GeneratedImage], forInput input: Aiuta.Input, ofSku sku: Aiuta.SkuInfo) {
        let results: [Aiuta.SessionResult] = generatedImages.map { .output($0, sku) }.reversed()

        guard let index = generationResults.firstIndex(of: .input(input, sku)) else {
            generationResults.append(contentsOf: results)
            return
        }

        generationResults.remove(at: index)

        if state < .result && sku == tryOnSku {
            generationResults.append(contentsOf: results)
        } else {
            generationResults.insert(contentsOf: results, at: index)
            tracker.track(.results(.update(sku: sku, generatedCount: generatedImages.count)))
        }
    }

    func changeState(_ targetState: Aiuta.SessionState, uuid: UUID) {
        guard uuid == sessionUuid else { return }
        state = targetState
    }
}

@available(iOS 13.0, *)
private extension AiutaSdkModelImpl {
    @MainActor func startTryOn(_ input: Aiuta.Inputs, uuid: UUID, origin: AnalyticEvent.TryOn.Origin) async {
        guard let sku = tryOnSku else { return }
        generationResults.append(.sku(sku))
        let imagesToHistory: Aiuta.UploadedImages
        switch input {
            case let .capturedImages(capturedImages):
                tracker.track(.tryOn(.start(origin: origin, sku: sku, photosCount: capturedImages.count)))
                delegate?.aiuta(eventOccurred: .tryOnStarted(skuId: sku.skuId, photosCount: capturedImages.count))
                imagesToHistory = await capturedImages.concurrentCompactMap { [self] capturedImage in
                    let input: Aiuta.Input = .capturedImage(capturedImage)
                    generationResults.append(.input(input, sku))
                    return await downsampleImageAndStart(capturedImage, sku: sku, ofInput: input, uuid: uuid, parallel: capturedImages.count)
                }
                Task { await updateHistory(imagesToHistory, sku: sku, uuid: uuid) }
            case let .uploadedImages(uploadedImages):
                tracker.track(.tryOn(.start(origin: origin, sku: sku, photosCount: uploadedImages.count)))
                delegate?.aiuta(eventOccurred: .tryOnStarted(skuId: sku.skuId, photosCount: uploadedImages.count))
                imagesToHistory = uploadedImages
                Task { await updateHistory(imagesToHistory, sku: sku, uuid: uuid) }
                await uploadedImages.concurrentForEach { [self] uploadedImage in
                    let input: Aiuta.Input = .uploadedImage(uploadedImage)
                    generationResults.append(.input(input, sku))
                    await startTryOn(uploadedImage, sku: sku, ofInput: input, uuid: uuid, parallel: uploadedImages.count)
                }
        }
    }

    @MainActor func updateHistory(_ imagesToHistory: Aiuta.UploadedImages, sku: Aiuta.SkuInfo, uuid: UUID) async {
        uploadsHistory.removeAll(where: { $0 == imagesToHistory })
        uploadsHistory.append(imagesToHistory)

        guard sku == tryOnSku, uuid == sessionUuid else { return }

        await imagesToHistory.concurrentForEach { [self] image in
            await preload(image.url)
        }

        onChangeUploads.fire(imagesToHistory)
    }

    @MainActor func downsampleImageAndStart(_ image: UIImage, sku: Aiuta.SkuInfo, ofInput input: Aiuta.Input, uuid: UUID, parallel: Int) async -> Aiuta.UploadedImage? {
        changeState(.processing(.uploadingImage), uuid: uuid)

        guard let imageData = await downsampleImage(image),
              let uploadedImage = await uploadImageData(imageData) else {
            tracker.track(.tryOn(.error(sku: sku, type: .uploadFailed)))
            changeState(.processing(.failed), uuid: uuid)
            reportError(forSku: sku, uuid: uuid)
            return nil
        }

        Task {
            await startTryOn(uploadedImage, sku: sku, ofInput: input, uuid: uuid, parallel: parallel)
        }
        return uploadedImage
    }

    @MainActor func downsampleImage(_ image: UIImage) async -> Data? {
        await withCheckedContinuation { continuation in
            dispatch(.user) { [self] in
                let downsample = downsampler.process(item: .image(image), options: .init(nil))
                let imageData = (downsample ?? image).jpegData(compressionQuality: 65)
                continuation.resume(returning: imageData)
            }
        }
    }

    @MainActor func uploadImageData(_ imageData: Data) async -> Aiuta.UploadedImage? {
        guard let uploadedImage: Aiuta.UploadedImage = try? await api.request(Aiuta.UploadedImage.Post(imageData: imageData))
        else { return nil }
        return uploadedImage
    }
}

@available(iOS 13.0, *)
private extension AiutaSdkModelImpl {
    @MainActor func startTryOn(_ image: Aiuta.UploadedImage, sku: Aiuta.SkuInfo, ofInput input: Aiuta.Input, uuid: UUID, parallel: Int) async {
        let startTime = Date()
        tracker.track(.tryOn(.generate(sku: sku)))
        changeState(.processing(.scanningBody), uuid: uuid)

        guard let start: Aiuta.TryOnStart = try? await api.request(Aiuta.TryOnStart.Post(uploadedImageId: image.id, skuId: sku.skuId, skuCatalogName: sku.skuCatalog)) else {
            tracker.track(.tryOn(.error(sku: sku, type: .tryOnStartFailed)))
            changeState(.processing(.failed), uuid: uuid)
            reportError(forSku: sku, uuid: uuid)
            return
        }

        var isGenerating = false
        var checkCount = 0

        var delays: [TimeInterval] = .init(repeating: 0.5, count: 12) + [1, 1, 2]

        repeat {
            if checkCount > 2, !isGenerating {
                isGenerating = true
                changeState(.processing(.generatingOutfit), uuid: uuid)
            }

            await asleep(.custom(delays.popLast() ?? 3))

            guard let operation: Aiuta.TryOnOperation = try? await api.request(Aiuta.TryOnOperation.Get(operationId: start.operationId)) else { continue }

            guard operation.status != .failed else {
                tracker.track(.tryOn(.error(sku: sku, type: .tryOnOperationFailed)))
                changeState(.processing(.failed), uuid: uuid)
                reportError(forSku: sku, uuid: uuid)
                return
            }

            if operation.status == .success {
                let duration = -startTime.timeIntervalSinceNow
                tracker.track(.tryOn(.finish(sku: sku, time: duration)))
                await operation.generatedImages.concurrentForEach { [self] generatedImage in
                    await preload(generatedImage.imageUrl)
                }

                if config.behavior.isHistoryAvailable {
                    generationHistory.insert(contentsOf: operation.generatedImages, at: 0)
                }
                guard uuid == sessionUuid else { return }
                addResults(operation.generatedImages, forInput: input, ofSku: sku)
                if sku == tryOnSku {
                    if state < .result {
                        tracker.track(.results(.open(sku: sku, time: duration, generatedCount: operation.generatedImages.count,
                                                     processingCount: parallel - 1, relatedCount: moreToTryOn.count)))
                        delegate?.aiuta(eventOccurred: .tryOnResultShown(skuId: sku.skuId))
                    }
                    changeState(.result, uuid: uuid)
                }
                return
            }

            checkCount += 1
        } while true
    }
}

@available(iOS 13.0, *)
extension AiutaSdkModelImpl {
    @MainActor func preload(_ urlString: String?) async {
        guard let url = URL(string: urlString) else { return }
        var isWaitingForKingfisherCallback = true
        await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url,
                                                   options: [
                                                       .downloadPriority(URLSessionTask.highPriority),
                                                       .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
                                                       .processor(DownsamplingImageProcessor(size: .init(square: 1500))),
                                                       .memoryCacheExpiration(.seconds(360)),
                                                       .diskCacheExpiration(.days(7)),
                                                       .diskCacheAccessExtendingExpiration(.cacheTime),
                                                       .backgroundDecode,
                                                   ]
            ) { _ in
                guard isWaitingForKingfisherCallback else { return }
                isWaitingForKingfisherCallback = false
                continuation.resume()
            }
        }
    }
}
