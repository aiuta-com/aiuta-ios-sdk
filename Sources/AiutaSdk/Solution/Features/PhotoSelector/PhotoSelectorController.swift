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
import UIKit

@available(iOS 13.0, *)
final class PhotoSelectorController: ComponentController<ContentBase> {
    let didPick = Signal<ImageSource>()

    @injected private var config: Aiuta.Configuration
    @injected private var history: HistoryModel
    @injected private var tracker: AnalyticTracker
    @injected private var session: SessionModel

    private let selectPhotoBulletin = PhotoSelectorBulletin()
    private let photoHistoryBulletin = PhotoHistoryBulletin()

    private var lock: LoadingBulletin?
    private var photoPicker: PhotoPicker?
    private let imagePickerDelegate = ImagePickerControllerDelegate()

    func choosePhoto() {
        if history.uploaded.items.count > 1 {
            showBulletin(photoHistoryBulletin)
            session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .uploadsHistoryOpened))
        } else {
            showBulletin(selectPhotoBulletin)
        }
    }

    override func setup() {
        photoPicker = PhotoPicker(vc: vc)
        photoPicker?.shouldTryLoadExifData = false

        selectPhotoBulletin.takeNewPhoto.onTouchUpInside.subscribe(with: self) { [unowned self] in
            takeNewPhoto()
        }

        selectPhotoBulletin.chooseFromLibrary.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if #available(iOS 14.0, *) {
                photoPicker?.pick(max: 1)
                session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .photoGalleryOpened))
            } else {
                chooseFromLibrary()
            }
        }

        photoHistoryBulletin.onSelect.subscribe(with: self) { [unowned self] image in
            tracker.track(.mainScreen(.selectOldPhotos(count: 1)))
            session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .uploadedPhotoSelected))
            photoHistoryBulletin.dismiss()
            didPick.fire(image)
        }

        photoHistoryBulletin.onDelete.subscribe(with: self) { [unowned self] image in
            history.removeUploaded(image)
            session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .uploadedPhotoDeleted))
        }

        photoHistoryBulletin.newPhotosButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(selectPhotoBulletin)
        }

        photoPicker?.willPick.subscribe(with: self) { [unowned self] in
            lock = showBulletin(LoadingBulletin(empty: false, isDismissable: false))
        }

        imagePickerDelegate.willPick.subscribe(with: self) { [unowned self] in
            lock = showBulletin(LoadingBulletin(empty: false, isDismissable: false))
        }

        photoPicker?.didPick.subscribe(with: self) { [unowned self] photos in
            tracker.track(.mainScreen(.selectNewPhotos(camera: 0, gallery: photos.count)))
            lock?.dismiss()
            if photos.isEmpty { return }
            session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .galleryPhotoSelected))
            pickPhotos(photos)
        }

        imagePickerDelegate.didPick.subscribe(with: self) { [unowned self] photo, source in
            switch source {
                case .camera:
                    tracker.track(.mainScreen(.selectNewPhotos(camera: 1, gallery: 0)))
                    session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .newPhotoTaken))
                case .photoLibrary:
                    tracker.track(.mainScreen(.selectNewPhotos(camera: 0, gallery: 1)))
                    session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .galleryPhotoSelected))
                default: break
            }
            lock?.dismiss()
            pickPhotos([photo])
        }

        photoHistoryBulletin.history = history.uploaded
    }

    private func pickPhotos(_ photos: [UIImage]) {
        Task {
            await selectPhotoBulletin.dismiss()
            guard let photo = photos.first else { return }
            didPick.fire(photo)
        }
    }
}

@available(iOS 13.0, *)
private extension PhotoSelectorController {
    func checkCameraPermission() -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                showPermissionAlert()
                return false
            case .restricted:
                return false
            default: return true
        }
    }

    func showPermissionAlert() {
        let alert = UIAlertController(title: L.dialogCameraPermissionTitle, message: L.dialogCameraPermissionDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L.dialogCameraPermissionConfirmButton, style: .default, handler: { _ in
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
        imagePickerDelegate.source = .camera
        picker.modalPresentationStyle = .overFullScreen
        picker.modalTransitionStyle = .coverVertical
        picker.delegate = imagePickerDelegate
        picker.sourceType = .camera
        picker.overrideUserInterfaceStyle = config.appearance.colors.style.userInterface
        vc?.present(picker, animated: true)
        session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .cameraOpened))
    }

    func chooseFromLibrary() {
        let picker = UIImagePickerController()
        imagePickerDelegate.source = .photoLibrary
        picker.modalPresentationStyle = .pageSheet
        picker.delegate = imagePickerDelegate
        picker.sourceType = .photoLibrary
        picker.overrideUserInterfaceStyle = config.appearance.colors.style.userInterface
        vc?.popover(picker)
        session.delegate?.aiuta(eventOccurred: .picker(pageId: page, event: .photoGalleryOpened))
    }
}

@available(iOS 13.0, *)
private extension PhotoSelectorController {
    var page: Aiuta.Event.Page { (vc as? PageRepresentable)?.page ?? .imagePicker }
}

@available(iOS 13.0, *)
private final class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let willPick = Signal<Void>()
    let didPick = Signal<(UIImage, UIImagePickerController.SourceType)>()
    var source: UIImagePickerController.SourceType = .photoLibrary
    let breadcrumbs = Breadcrumbs()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        willPick.fire()
        picker.dismiss()
        Task { await pick(image, from: source) }
    }

    @MainActor func pick(_ image: UIImage, from source: UIImagePickerController.SourceType) async {
        var loaders = [try? await image.prefetch(.hiResImage, breadcrumbs: breadcrumbs)]
        didPick.fire((image, source))
        await asleep(.halfOfSecond)
        loaders.removeAll()
    }
}
