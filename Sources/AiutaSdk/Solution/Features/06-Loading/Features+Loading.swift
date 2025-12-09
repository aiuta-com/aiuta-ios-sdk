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
    @injected private var tryOn: Sdk.Core.TryOn
    @injected private var history: Sdk.Core.History
    @injected private var session: Sdk.Core.Session
    @injected private var config: Sdk.Configuration
    @injected private var tracker: AnalyticTracker

    private var source: ImageSource?
    private var origin: Aiuta.Event.TryOn.Origin = .unknown

    convenience init(_ source: ImageSource, origin: Aiuta.Event.TryOn.Origin) {
        self.init()
        self.source = source
        self.origin = origin
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onAction.subscribe(with: self) { [unowned self] in
            popoverOrCover(HistoryViewController())
        }

        ui.navBar.isActionAvailable = history.hasGenerations
        ui.status.text = (source?.knownRemoteId).isSome
            ? ds.strings.tryOnLoadingStatusScanningBody
            : ds.strings.tryOnLoadingStatusUploadingImage

        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            if !history.hasGenerations { ui.navBar.isActionAvailable = false }
        }

        ui.errorSnackbar.bar.tryAgain.onTouchUpInside.subscribe(with: self) { [unowned self] in
            origin = .retryNotification
            Task { await start() }
        }

        if #available(iOS 15.0.0, *), config.features.tryOn.tryGeneratePersonSegmentation {
            ui.animator.imageView.gotImage.subscribe(with: self) { [unowned self] in
                generatePersonSegmentation()
            }
        }

        ui.animator.imageView.source = source
        tracker.track(.page(pageId: page, productIds: session.products.ids))
    }

    override func start() async {
        do {
            ui.start()
            let start = TimeInterval.now
            let products = session.products
            tracker.track(.tryOn(event: .initiated(origin: origin),
                                 pageId: page, productIds: products.ids))


            guard let source else {
                throw Sdk.Core.TryOnError.error(.preparePhotoFailed)
            }

            let stats = try await tryOn.tryOn(source, with: products) { [weak self, origin] status in
                guard let self else { return }
                
                switch status {
                    case .uploadingImage:
                        self.ui.status.text = self.config.strings.tryOnLoadingStatusUploadingImage
                    case .imageUploaded:
                        self.tracker.track(.tryOn(event: .photoUploaded,
                                                  pageId: .loading, productIds: products.ids))
                    case .scanningBody:
                        self.ui.status.text = self.config.strings.tryOnLoadingStatusScanningBody
                        self.tracker.track(.tryOn(event: .tryOnStarted(origin: origin),
                                                  pageId: .loading, productIds: products.ids))
                    case .generatingOutfit:
                        self.ui.status.text = self.config.strings.tryOnLoadingStatusGeneratingOutfit
                }
            }

            let totalDuration = TimeInterval.now - start + AsyncDelayTime.quarterOfSecond.seconds
            tracker.track(.tryOn(event: .tryOnFinished(uploadDuration: stats.uploadDuration,
                                                       tryOnDuration: stats.tryOnDuration,
                                                       downloadDuration: stats.downloadDuration,
                                                       totalDuration: totalDuration),
                                 pageId: page, productIds: session.products.ids))

            replace(with: ResulstsViewController(), crossFadeDuration: .quarterOfSecond)

        } catch Sdk.Core.TryOnError.terminate {
            ui.stop()

            tracker.track(.tryOn(event: .tryOnAborted(reason: .userCancelled),
                                 pageId: page, productIds: session.products.ids))

        } catch Sdk.Core.TryOnError.abort {
            ui.stop()

            tracker.track(.tryOn(event: .tryOnAborted(reason: .operationAborted),
                                 pageId: page, productIds: session.products.ids))

            showAlert(message: config.strings.invalidInputImageDescription) { alert in
                alert.addAction(title: config.strings.invalidInputImageChangePhotoButton,
                                style: .cancel).subscribe(with: self) { [unowned self] in
                    replace(with: Sdk.Features.TryOn(), crossFadeDuration: .quarterOfSecond)
                }
            }
        } catch {
            ui.stop()

            switch error {
                case let Sdk.Core.TryOnError.error(type, _):
                    tracker.track(.tryOn(event: .tryOnError(type: type, message: error.localizedDescription),
                                         pageId: page, productIds: session.products.ids))
                default:
                    tracker.track(.tryOn(event: .tryOnError(type: .internalSdkError, message: error.localizedDescription),
                                         pageId: page, productIds: session.products.ids))
            }

            ui.errorSnackbar.isVisible = true
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
