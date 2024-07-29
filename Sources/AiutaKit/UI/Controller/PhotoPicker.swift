//
//  Created by nGrey on 06.12.2023.
//

import Foundation
import PhotosUI

@MainActor @_spi(Aiuta) public final class PhotoPicker {
    public enum PickError: Error {
        case loadFailed
    }

    public let willPick = Signal<Void>()
    public let didPick = Signal<[UIImage]>()

    public var shouldTryLoadExifData = true
    public var concurrentLoadChunkSize = 4

    private weak var vc: UIViewController?
    private weak var anchor: ContentBase?

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
extension PhotoPicker: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        Task { await pick(results, from: picker) }
    }
}

@available(iOS 14.0, *)
@MainActor private extension PhotoPicker {
    private func openPHPicker(vc: UIViewController, selectionLimit: Int) {
        var phPickerConfig = PHPickerConfiguration()
        phPickerConfig.selectionLimit = selectionLimit
        phPickerConfig.filter = PHPickerFilter.images
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        phPickerVC.modalPresentationStyle = .popover
        vc.present(phPickerVC, attachedTo: anchor)
    }

    func pick(_ results: [PHPickerResult], from picker: PHPickerViewController) async {
        if !results.isEmpty { willPick.fire() }
        async let isDismissed = dismiss(picker)
        let images = await results.chunked(by: concurrentLoadChunkSize).asyncMap { chunk in
            await chunk.concurrentCompactMap { [self] result in
                await downsample(await load(result, tryLoadExifData: shouldTryLoadExifData))
            }
        }.flattened()
        var loaders = await images.concurrentMap { image in
            try? await image.prefetch(.thumbnails, breadcrumbs: Breadcrumbs())
        }
        if await isDismissed {
            didPick.fire(images)
        }
        await asleep(.halfOfSecond)
        loaders.removeAll()
    }

    private func dismiss(_ picker: PHPickerViewController) async -> Bool {
        await withCheckedContinuation { continuation in
            picker.dismiss(animated: true) {
                continuation.resume(returning: true)
            }
        }
    }

    private func load(_ result: PHPickerResult, tryLoadExifData: Bool) async -> UIImage? {
        try? await withCheckedThrowingContinuation { continuation in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    continuation.resume(throwing: PickError.loadFailed)
                    return
                }

                guard tryLoadExifData else {
                    continuation.resume(returning: image)
                    return
                }

                result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let exif = ExifData(data) { image.createdAt = exif.date }
                    continuation.resume(returning: image)
                }
            }
        }
    }

    private func downsample(_ image: UIImage?) async -> UIImage? {
        guard let image else { return nil }
        let downsample = try? await Downsampler(image, quality: .hiResImage, breadcrumbs: Breadcrumbs()).fetch()
        return downsample ?? image
    }
}
