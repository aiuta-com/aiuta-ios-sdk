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
import AVFoundation
import Resolver
import UIKit

@available(iOS 13.0, *)
final class AiutaPhotoSelectorController: ComponentController<AiutaTryOnView> {
    @injected private var model: AiutaSdkModel
    @injected private var config: Aiuta.Configuration
    @injected private var tracker: AnalyticTracker

    private var inputs: Aiuta.Inputs? {
        didSet {
            guard oldValue != inputs else { return }
            ui.processingLoader.preview.imageView.inputs = inputs
            ui.photoSelector.inputs = inputs
            ui.starter.view.isVisible = inputs.isSome && model.state <= .photoSelecting
        }
    }

    private let changePhotoBulletin = AiutaPhotoSelectorBulletin()
    private let photoHistoryBulletin = AiutaPhotoHistoryBulletin()
    private var photoPicker: AiutaPhotoPicker?
    private var lock: LoadingBulletin?
    private var imagePickerDelegate: ImagePickerControllerDelegate? {
        didSet {
            oldValue?.didPickPhoto.cancelAllSubscriptions()
            imagePickerDelegate?.didPickPhoto.subscribe(with: self) { [unowned self] image, source in
                switch source {
                    case .camera:
                        tracker.track(.mainScreen(.selectNewPhotos(camera: 1, gallery: 0)))
                        model.delegate?.aiuta(eventOccurred: .newPhotoTaken)
                    case .photoLibrary:
                        tracker.track(.mainScreen(.selectNewPhotos(camera: 0, gallery: 1)))
                        model.delegate?.aiuta(eventOccurred: .galleryPhotosSelected(photosCount: 1))
                    default: break
                }
                pickPhotos([image])
            }
        }
    }

    override func setup() {
        changePhotoBulletin.takeNewPhoto.onTouchUpInside.subscribe(with: self) { [unowned self] in
            takeNewPhoto()
        }

        changePhotoBulletin.chooseFromLibrary.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if #available(iOS 14.0, *) {
                photoPicker?.pick(max: clamp(config.behavior.photoSelectionLimit, min: 1, max: 10))
            } else {
                chooseFromLibrary()
            }
        }

        ui.photoSelector.onChangePhoto.subscribe(with: self) { [unowned self] in
            if model.uploadsHistory.count > 1 {
                tracker.track(.mainScreen(.changePhoto(hasCurrent: true, hasHistory: true)))
                showBulletin(photoHistoryBulletin)
            } else {
                tracker.track(.mainScreen(.changePhoto(hasCurrent: !model.uploadsHistory.isEmpty, hasHistory: false)))
                showBulletin(changePhotoBulletin)
            }
        }

        photoHistoryBulletin.newPhotosButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(changePhotoBulletin)
        }

        photoPicker = AiutaPhotoPicker(vc: vc, anchor: changePhotoBulletin.chooseFromLibrary)

        photoPicker?.willPick.subscribe(with: self) { [unowned self] in
            lock = showBulletin(LoadingBulletin(empty: false, isDismissable: true))
        }

        photoPicker?.didPick.subscribe(with: self) { [unowned self] photos in
            tracker.track(.mainScreen(.selectNewPhotos(camera: 0, gallery: photos.count)))
            model.delegate?.aiuta(eventOccurred: .galleryPhotosSelected(photosCount: photos.count))
            lock?.dismiss()
            if photos.isEmpty { return }
            pickPhotos(photos)
        }

        photoHistoryBulletin.onSelectPack.subscribe(with: self) { [unowned self] images in
            tracker.track(.mainScreen(.selectOldPhotos(count: images.count)))
            photoHistoryBulletin.dismiss()
            inputs = .uploadedImages(images)
            startProcessing(.selectPhotos)
        }

        photoHistoryBulletin.onDeletePack.subscribe(with: self) { [unowned self] images in
            model.uploadsHistory.removeAll(where: { $0 == images })
            photoHistoryBulletin.history = model.uploadsHistory.reversed()
        }

        ui.starter.go.onTouchUpInside.subscribe(with: self) { [unowned self] in
            startProcessing(.tryOnButton)
        }

        if let lastUploads = model.uploadsHistory.last {
            inputs = .uploadedImages(lastUploads)
        }

        model.onChangeUploads.subscribe(with: self) { [unowned self] uploads in
            inputs = .uploadedImages(uploads)
        }

        model.onChangeUploads.subscribe(with: self) { [unowned self] _ in
            photoHistoryBulletin.history = model.uploadsHistory.reversed()
        }

        photoHistoryBulletin.history = model.uploadsHistory.reversed()
    }

    private func pickPhotos(_ photos: [UIImage]) {
        inputs = .capturedImages(photos)
        Task {
            await changePhotoBulletin.dismiss()
            startProcessing(.selectPhotos)
        }
    }

    private func startProcessing(_ origin: AnalyticEvent.TryOn.Origin) {
        guard let inputs else { return }
        model.startTryOn(inputs, origin: origin)
    }
}

@available(iOS 13.0, *)
private extension AiutaPhotoSelectorController {
    func checkCameraPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                showPermissionAlert()
                return false
            case .restricted: return false
            default: return true
        }
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: nil, message: L.imageSelectorCameraPermission, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.settings, style: .default, handler: { _ in
            let app = UIApplication.shared
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                  app.canOpenURL(settingsUrl)
            else { return }
            app.open(settingsUrl)
        }))
        alert.addAction(UIAlertAction(title: L.cancel, style: .cancel, handler: nil))
        vc?.present(alert, animated: true, completion: nil)
    }

    func takeNewPhoto() {
        guard checkCameraPermission() else { return }

        let picker = UIImagePickerController()
        imagePickerDelegate = ImagePickerControllerDelegate(.camera)
        picker.delegate = imagePickerDelegate
        picker.modalPresentationStyle = .popover
        picker.sourceType = .camera

        vc?.present(picker, attachedTo: changePhotoBulletin.takeNewPhoto)
    }

    func chooseFromLibrary() {
        let picker = UIImagePickerController()
        imagePickerDelegate = ImagePickerControllerDelegate(.photoLibrary)
        picker.delegate = imagePickerDelegate
        picker.modalPresentationStyle = .popover
        picker.sourceType = .photoLibrary

        vc?.present(picker, attachedTo: changePhotoBulletin.chooseFromLibrary)
    }
}

private final class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let didPickPhoto = Signal<(UIImage, UIImagePickerController.SourceType)>()
    let source: UIImagePickerController.SourceType

    init(_ source: UIImagePickerController.SourceType) {
        self.source = source
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss()
        guard let image = info[.originalImage] as? UIImage else { return }
        didPickPhoto.fire((image, source))
    }
}
