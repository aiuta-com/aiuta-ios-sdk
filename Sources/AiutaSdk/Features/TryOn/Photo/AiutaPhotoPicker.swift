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
import PhotosUI

@MainActor final class AiutaPhotoPicker {
    private weak var vc: UIViewController?
    private weak var anchor: ContentBase?

    public let willPick = Signal<Void>()
    public let didPick = Signal<[UIImage]>()

    private let downsampler = DownsamplingImageProcessor(size: .init(square: 1500))

    public init(vc: UIViewController?, anchor: ContentBase?) {
        self.vc = vc
        self.anchor = anchor
    }

    @available(iOS 14.0, *)
    public func pick(max selectionLimit: Int = 0) {
        guard let vc else { return }
        openPHPicker(vc: vc, selectionLimit: selectionLimit)
    }
}

@available(iOS 14.0, *)
extension AiutaPhotoPicker: PHPickerViewControllerDelegate {
    private func openPHPicker(vc: UIViewController, selectionLimit: Int) {
        var phPickerConfig = PHPickerConfiguration()
        phPickerConfig.selectionLimit = selectionLimit
        phPickerConfig.filter = PHPickerFilter.images
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        phPickerVC.modalPresentationStyle = .popover
        vc.present(phPickerVC, attachedTo: anchor)
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty { willPick.fire() }
        Task {
            async let isDismissed = dismiss(picker)
            let images = await results.asyncCompactMap { await downsample(await load($0)) }
            if await isDismissed { didPick.fire(images) }
        }
    }

    private func dismiss(_ picker: PHPickerViewController) async -> Bool {
        await withCheckedContinuation { continuation in
            picker.dismiss(animated: true) {
                continuation.resume(returning: true)
            }
        }
    }

    private func load(_ result: PHPickerResult) async -> UIImage? {
        await withCheckedContinuation { continuation in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, _ in
                continuation.resume(returning: reading as? UIImage)
            }
        }
    }

    func downsample(_ image: UIImage?) async -> UIImage? {
        guard let image else { return nil }
        return await withCheckedContinuation { continuation in
            dispatch(.user) { [self] in
                let downsample = downsampler.process(item: .image(image), options: .init(nil))
                continuation.resume(returning: downsample ?? image)
            }
        }
    }
}
