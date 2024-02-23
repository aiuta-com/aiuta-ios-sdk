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


import UIKit

final class AiutaPhotoSelectorController: ComponentController<AiutaTryOnView> {
    var didPickPhoto: Signal<UIImage> {
        imagePickerDelegate.didPickPhoto
    }
    
    var lastUploadedImage: Aiuta.UploadedImage? {
        didSet {
            if let lastUploadedImage {
                ui.processingLoader.preview.imageView.imageUrl = lastUploadedImage.url
                ui.photoSelector.source = .uploadedImage(lastUploadedImage)
                ui.starter.view.isVisible = true
            } else {
                ui.photoSelector.source = .placeholder
                ui.starter.view.isVisible = false
            }
        }
    }

    private let changePhotoBulletin = AiutaPhotoSelectorBulletin()
    private let imagePickerDelegate = ImagePickerControllerDelegate()

    override func setup() {
        changePhotoBulletin.takeNewPhoto.onTouchUpInside.subscribe(with: self) { [unowned self] in
            takeNewPhoto()
        }

        changePhotoBulletin.chooseFromLibrary.onTouchUpInside.subscribe(with: self) { [unowned self] in
            chooseFromLibrary()
        }

        ui.photoSelector.changePhoto.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(changePhotoBulletin)
        }
    }
}

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
