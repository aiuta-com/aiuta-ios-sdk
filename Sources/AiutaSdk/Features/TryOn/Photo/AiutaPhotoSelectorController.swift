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

import Resolver
import UIKit

@available(iOS 13.0, *)
final class AiutaPhotoSelectorController: ComponentController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel
    @Injected private var config: Aiuta.Configuration

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
    private let imagePickerDelegate = ImagePickerControllerDelegate()
    private var photoPicker: AiutaPhotoPicker?
    private var lock: LoadingBulletin?

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
                showBulletin(photoHistoryBulletin)
            } else {
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
            lock?.dismiss()
            if photos.isEmpty { return }
            pickPhotos(photos)
        }

        imagePickerDelegate.didPickPhoto.subscribe(with: self) { [unowned self] image in
            pickPhotos([image])
        }

        photoHistoryBulletin.onSelectPack.subscribe(with: self) { [unowned self] images in
            photoHistoryBulletin.dismiss()
            inputs = .uploadedImages(images)
            startProcessing()
        }

        photoHistoryBulletin.onDeletePack.subscribe(with: self) { [unowned self] images in
            model.uploadsHistory.removeAll(where: { $0 == images })
            photoHistoryBulletin.history = model.uploadsHistory.reversed()
        }

        ui.starter.go.onTouchUpInside.subscribe(with: self) { [unowned self] in
            startProcessing()
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
            startProcessing()
        }
    }

    private func startProcessing() {
        guard let inputs else { return }
        model.startTryOn(inputs)
    }
}

@available(iOS 13.0, *)
private extension AiutaPhotoSelectorController {
    func takeNewPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = imagePickerDelegate
        picker.modalPresentationStyle = .popover
        picker.sourceType = .camera

        vc?.present(picker, attachedTo: changePhotoBulletin.takeNewPhoto)
    }

    func chooseFromLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = imagePickerDelegate
        picker.modalPresentationStyle = .popover
        picker.sourceType = .photoLibrary

        vc?.present(picker, attachedTo: changePhotoBulletin.chooseFromLibrary)
    }
}

private final class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let didPickPhoto = Signal<UIImage>()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss()
        guard let image = info[.originalImage] as? UIImage else { return }
        didPickPhoto.fire(image)
    }
}
