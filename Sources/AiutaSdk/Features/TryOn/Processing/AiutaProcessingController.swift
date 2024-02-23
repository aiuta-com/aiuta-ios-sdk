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


import Kingfisher
import Resolver
import UIKit

@available(iOS 13.0, *)
final class AiutaProcessingController: ComponentController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel

    let didUploadImage = Signal<Aiuta.UploadedImage>()
    let didCompleteProcessing = Signal<Aiuta.TryOnOperation>()

    var sku: Aiuta.SkuInfo? {
        didSet {
            guard oldValue != sku else { return }
            checkSku()
        }
    }

    var lastUploadedImage: Aiuta.UploadedImage?
    private var isReady: Bool?

    @defaults(key: "lastOperation", defaultValue: nil)
    private var lastOperation: Aiuta.TryOnOperation?

    @Injected private var api: ApiService
    private let downsampler = DownsamplingImageProcessor(size: .init(square: 1500))

    override func setup() {
        ui.starter.go.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let lastUploadedImage else { return }
            startTryOn(uploadedImage: lastUploadedImage)
        }

        ui.errorSnackbar.bar.gestures.onSwipe(.down, with: self) { [unowned self] _ in
            ui.errorSnackbar.isVisible = false
        }

        ui.errorSnackbar.bar.gestures.onTap(with: self) { [unowned self] _ in
            ui.errorSnackbar.isVisible = false
        }

        ui.errorSnackbar.bar.close.onTouchUpInside.subscribe(with: self) { [unowned self] in
            ui.errorSnackbar.isVisible = false
        }
    }

    func startTryOn(uploadedImage: Aiuta.UploadedImage) {
        guard checkIsReady() else { return }
        Task { await startTryOn(uploadedImage) }
    }

    func startTryOn(selectedImage: UIImage) {
        guard checkIsReady() else { return }
        Task { await downsampleImageAndStart(selectedImage) }
    }

    func checkSku() {
        guard let sku else { return }
        isReady = nil
        Task {
            do {
                let test: Aiuta.Sku = try await api.request(Aiuta.Sku.Get(skuId: sku.skuId, skuCatalogName: sku.skuCatalog))
                isReady = test.isReady
            } catch {
                isReady = false
            }
        }
    }

    func checkIsReady() -> Bool {
        guard let isReady else { return false }
        if !isReady {
            showError("This product is not supported.\nPlease contact the seller’s support service")
        }
        return isReady
    }
}

@available(iOS 13.0, *)
private extension AiutaProcessingController {
    func downsampleImageAndStart(_ image: UIImage) async {
        let loader = showBulletin(LoadingBulletin())
        let result = await downsampleImage(image)
        ui.photoSelector.source = .capturedImage(result)
        ui.processingLoader.preview.imageView.image = result
        ui.mode = .loading
        await loader.dismiss()
        guard let uploadedImage = await uploadImage(result) else {
            ui.processingLoader.status.label.text = "Failed"
            return
        }
        ui.processingLoader.status.label.text = "Scanning your body"
        ui.photoSelector.source = .uploadedImage(uploadedImage)
        didUploadImage.fire(uploadedImage)
        lastUploadedImage = uploadedImage
        await startTryOn(uploadedImage)
    }

    func downsampleImage(_ image: UIImage) async -> UIImage {
        await withCheckedContinuation { continuation in
            dispatch(.user) { [self] in
                let downsample = downsampler.process(item: .image(image), options: .init(nil))
                continuation.resume(returning: downsample ?? image)
            }
        }
    }

    func uploadImage(_ image: UIImage) async -> Aiuta.UploadedImage? {
        ui.processingLoader.status.label.text = "Uploading image"
        guard let imageData = image.jpegData(compressionQuality: 0.65),
              let uploadedImage: Aiuta.UploadedImage = try? await api.request(Aiuta.UploadedImage.Post(imageData: imageData))
        else { return nil }
        return uploadedImage
    }

    func showError(_ text: String = "Something went wrong.\nPlease try again later") {
        ui.errorSnackbar.bar.label.text = text
        ui.errorSnackbar.isVisible = true
    }
}

@available(iOS 13.0, *)
private extension AiutaProcessingController {
    func startTryOn(_ image: Aiuta.UploadedImage) async {
        ui.mode = .loading
        ui.processingLoader.status.label.text = "Scanning your body"

//        if let lastOperation {
//            didCompleteProcessing.fire(lastOperation)
//            return
//        }

        guard let sku,
              let start: Aiuta.TryOnStart = try? await api.request(Aiuta.TryOnStart.Post(uploadedImageId: image.id, skuId: sku.skuId, skuCatalogName: sku.skuCatalog))
        else {
            ui.processingLoader.status.label.text = "Failed"
            ui.mode = .photoSelecting
            showError()
            return
        }

        var isGenerating = false
        var checkCount = 0

        repeat {
            if checkCount > 3, !isGenerating {
                isGenerating = true
                ui.processingLoader.status.label.text = "Generating outfit"
            }

            await asleep(.twoSeconds)
            guard let operation: Aiuta.TryOnOperation = try? await api.request(Aiuta.TryOnOperation.Get(operationId: start.operationId)) else { continue }

            guard operation.status != .failed else {
                ui.processingLoader.status.label.text = "Failed"
                ui.mode = .photoSelecting
                showError()
                return
            }

            if operation.status == .success {
                model.generationHistory.insert(contentsOf: operation.generatedImages, at: 0)
                lastOperation = operation
                didCompleteProcessing.fire(operation)
                return
            }

            checkCount += 1
        } while true
    }
}
