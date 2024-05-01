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

import LinkPresentation
import UIKit
import UniformTypeIdentifiers

@_spi(Aiuta) public extension UIViewController {
    @available(iOS 13.0.0, *)
    @discardableResult
    func share(image: UIImage, title: String? = nil, additions: [Any] = []) async -> ShareResult {
        await share(images: [image], title: title, additions: additions)
    }

    @available(iOS 13.0.0, *)
    @discardableResult
    func share(images: [UIImage], title: String? = nil, additions: [Any] = []) async -> ShareResult {
        var isWaitingForResult = true
        return await withCheckedContinuation { continuation in
            share(images: images, title: title, additions: additions) { shareResult in
                guard isWaitingForResult else { return }
                isWaitingForResult = false
                continuation.resume(returning: shareResult)
            }
        }
    }

    func share(text: String, title: String) {
        let fileName = "\(title.replacingOccurrences(of: " ", with: "_").lowercased()).log.txt"
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do { try text.write(to: filePath, atomically: false, encoding: String.Encoding.utf8) } catch { return }
        let activityViewController = UIActivityViewController(
            activityItems: [filePath],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            try? FileManager.default.removeItem(at: filePath)
        }
        present(activityViewController, animated: true, completion: nil)
    }

    func share(image: UIImage, title: String? = nil, additions: [Any] = [], completion: ((ShareResult) -> Void)? = nil) {
        share(images: [image], title: title, additions: additions, completion: completion)
    }

    func share(images: [UIImage], title: String? = nil, additions: [Any] = [], completion: ((ShareResult) -> Void)? = nil) {
        trace(i: "<", "Sharing")
        let activityViewController = UIActivityViewController(
            activityItems: images.compactMap {
                ShareableImage($0, title: title)
            } + additions.compactMap { ShareableAddition(some: $0) }, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.completionWithItemsHandler = { activityType, completed, _, activityError in
            let result = ShareResult(activity: activityType?.rawValue, completed: completed, error: activityError)
            trace(i: "<", result)
            completion?(result)
        }
        present(activityViewController, animated: true, completion: nil)
    }

    /** Alternative way
     func share(images: [UIImage], title: String? = nil, completion: ((ShareResult) -> Void)? = nil) {
         trace(i: "<", "Sharing")
         let files = images.indexed.compactMap { i, image in
             temp(image: image, title: title, number: images.count > 1 ? i : nil)
         }
         let activityViewController = UIActivityViewController(activityItems: files, applicationActivities: nil)
         activityViewController.popoverPresentationController?.sourceView = view
         activityViewController.completionWithItemsHandler = { activityType, completed, _, activityError in
             files.forEach { try? FileManager.default.removeItem(at: $0) }
             let result = ShareResult(activity: activityType?.rawValue, completed: completed, error: activityError)
             trace(i: "<", result)
             completion?(result)
         }
         present(activityViewController, animated: true, completion: nil)
     }

     private func temp(image: UIImage, title: String?, number: Int?) -> URL? {
         guard let data = image.jpegData(compressionQuality: 1) else { return nil }
         let name: String
         if let number { name = "\(title ?? "Image") \(number + 1).jpg" }
         else { name = "Image.jpg" }
         let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(name)
         do {
             try data.write(to: filePath)
             return filePath
         } catch {
             return nil
         }
     }
     **/
}

@_spi(Aiuta) public enum ShareResult: CustomDebugStringConvertible {
    case succeeded(activity: String?)
    case canceled(activity: String?)
    case failed(activity: String?, error: Error)

    public var activity: String? {
        switch self {
            case let .succeeded(activity): return activity
            case let .canceled(activity): return activity
            case let .failed(activity, _): return activity
        }
    }

    public var isSucceeded: Bool {
        switch self {
            case .succeeded: return true
            default: return false
        }
    }

    init(activity: String?, completed: Bool, error: Error?) {
        if completed {
            self = .succeeded(activity: activity)
        } else if let error {
            self = .failed(activity: activity, error: error)
        } else {
            self = .canceled(activity: activity)
        }
    }

    public var debugDescription: String {
        let postfix: String
        if let activity { postfix = " to \(activity)" }
        else { postfix = "" }
        switch self {
            case .succeeded: return "Shared successfully\(postfix)"
            case .canceled: return "Sharing\(postfix) canceled"
            case let .failed(_, error): return "Share\(postfix) failed with \(error.localizedDescription)"
        }
    }
}

@_spi(Aiuta) public struct ShareError: Error, LocalizedError {
    public var errorDescription: String?

    public init(_ errorDescription: String? = nil) {
        self.errorDescription = errorDescription
    }
}

final class ShareableImage: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let title: String?

    init(_ image: UIImage, title: String?) {
        self.title = title
        self.image = image
        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        image
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        image
    }

    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        if #available(iOS 14.0, *) {
            return UTType.jpeg.identifier
        } else {
            return "public.jpeg"
        }
    }

    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.iconProvider = NSItemProvider(object: image)
        metadata.imageProvider = NSItemProvider(object: image)
        metadata.title = title ?? "Image"
        return metadata
    }
}

final class ShareableAddition: NSObject, UIActivityItemSource {
    let some: Any

    init?(some: Any?) {
        guard let some else { return nil }
        self.some = some
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return some
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        guard let activityType else { return nil }
        trace(activityType.rawValue)
        switch activityType.rawValue {
            case "com.burbn.instagram.shareextension",
                 "com.tinyspeck.chatlyio.share": return nil
            default: return some
        }
    }
}

// net.whatsapp.WhatsApp.ShareExtension
// ph.telegra.Telegraph.Share
// com.burbn.instagram.shareextension
// com.tinyspeck.chatlyio.share - Slack
// com.apple.UIKit.activity.Mail
// com.apple.UIKit.activity.Message
