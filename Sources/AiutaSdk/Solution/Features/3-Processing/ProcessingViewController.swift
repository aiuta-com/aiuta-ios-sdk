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
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
import Vision

@available(iOS 13.0.0, *)
final class ProcessingViewController: ViewController<ProcessingView> {
    @injected private var tryOnModel: TryOnModel
    @injected private var history: HistoryModel
    @injected private var session: SessionModel
    @injected private var tracker: AnalyticTracker
    @injected private var config: Aiuta.Configuration

    private var source: ImageSource?

    convenience init(_ source: ImageSource) {
        self.init()
        self.source = source
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onAction.subscribe(with: self) { [unowned self] in
            popoverOrCover(HistoryViewController())
        }

        ui.navBar.isActionAvailable = history.hasGenerations
        ui.status.text = (source?.knownRemoteId).isSome ? L.loadingScanningBody : L.loadingUploadingImage

        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            if !history.hasGenerations { ui.navBar.isActionAvailable = false }
        }

        ui.errorSnackbar.bar.tryAgain.onTouchUpInside.subscribe(with: self) { [unowned self] in
            Task { await start() }
        }

        if #available(iOS 15.0.0, *), config.behavior.tryGeneratePersonSegmentation {
            ui.animator.imageView.gotImage.subscribe(with: self) { [unowned self] in
                generatePersonSegmentation()
            }
        }

        ui.animator.imageView.source = source
        session.track(.page(page: page, product: session.activeSku))
        tracker.track(.tryOn(.start(origin: .selectPhotos, sku: session.activeSku, photosCount: 1)))
    }

    override func start() async {
        let sku = session.activeSku
        do {
            guard let source else { throw TryOnError.prepareImageFailed }
            ui.errorSnackbar.isVisible = false
            ui.animator.isAnimating = true
            try await tryOnModel.tryOn(source, with: session.activeSku) { [weak self] status in
                switch status {
                    case .uploadingImage: self?.ui.status.text = L.loadingUploadingImage
                    case .scanningBody: self?.ui.status.text = L.loadingScanningBody
                        self?.session.track(.tryOn(event: .tryOnStarted, message: nil, page: .loading, product: sku))
                    case .generatingOutfit: self?.ui.status.text = L.loadingGeneratingOutfit
                }
            }
            ui.animator.isAnimating = false
            session.track(.tryOn(event: .tryOnFinished, message: nil, page: .loading, product: sku))
            replace(with: ResulstsViewController(), crossFadeDuration: .quarterOfSecond)
        } catch TryOnError.tryOnAborted {
            ui.status.text = nil
            ui.animator.isAnimating = false
            session.track(.tryOn(event: .tryOnAborted, message: TryOnError.tryOnAborted.localizedDescription, page: .loading, product: sku))
            showAlert(message: L.dialogInvalidImageDescription) { alert in
                alert.addAction(title: L.imageSelectorChangeButton, style: .cancel).subscribe(with: self) { [unowned self] in
                    replace(with: TryOnViewController(), crossFadeDuration: .quarterOfSecond)
                }
            }
        } catch {
            ui.status.text = nil
            ui.errorSnackbar.isVisible = true
            ui.animator.isAnimating = false
            session.track(.tryOn(event: .tryOnError, message: error.localizedDescription, page: .loading, product: sku))
        }
    }
}

@available(iOS 15.0.0, *)
private extension ProcessingViewController {
    func generatePersonSegmentation() {
        guard let image = ui.animator.imageView.image?.cgImage else { return }

        let segmentationImageSizeLimit = 5000
        guard image.width < segmentationImageSizeLimit,
              image.height < segmentationImageSizeLimit else { return }

        dispatch(.user) { [weak self] in
            guard let self else { return }
            do {
                let request = VNGeneratePersonSegmentationRequest()
                request.qualityLevel = .accurate

                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                try requestHandler.perform([request])

                guard let mask = request.results?.first else {
                    trace("Error generating person segmentation mask")
                    return
                }

                let maskImage = CIImage(cvPixelBuffer: mask.pixelBuffer)
                guard let maskedImage = blendImages(foreground: CIImage(cgImage: image), mask: maskImage) else {
                    trace("Error generating person segmentation mask image")
                    return
                }

                let overlayImage = UIImage(ciImage: maskedImage)

                dispatch(.main) { [self] in
                    // self.ui.imageWithLoader.overlay.source = overlayImage
                    self.ui.animator.border.source = overlayImage
                }
            } catch {
                trace("Error processing person segmentation request")
            }
        }
    }

    func blendImages(background: CIImage = CIImage.empty(), foreground: CIImage, mask: CIImage) -> CIImage? {
        let maskScaleX = foreground.extent.width / mask.extent.width
        let maskScaleY = foreground.extent.height / mask.extent.height
        let maskScaled = mask.transformed(
            by: __CGAffineTransformMake(maskScaleX, 0, 0, maskScaleY, 0, 0))

        let backgroundScaleX = (foreground.extent.width / background.extent.width)
        let backgroundScaleY = (foreground.extent.height / background.extent.height)
        let backgroundScaled = background.transformed(
            by: __CGAffineTransformMake(backgroundScaleX, 0, 0, backgroundScaleY, 0, 0))

        let blendFilter = CIFilter.blendWithMask()
        blendFilter.inputImage = foreground
        blendFilter.backgroundImage = backgroundScaled
        blendFilter.maskImage = maskScaled

        return blendFilter.outputImage
    }
}

@available(iOS 13.0.0, *)
extension ProcessingViewController: PageRepresentable {
    var page: Aiuta.Event.Page { .loading }
    var isSafeToDismiss: Bool { false }
}
