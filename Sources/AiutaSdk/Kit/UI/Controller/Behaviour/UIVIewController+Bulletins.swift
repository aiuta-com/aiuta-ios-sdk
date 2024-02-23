//
// Created by nGrey on 27.02.2023.
//

import MessageUI
import Photos
import PhotosUI
import SafariServices
import UIKit

extension UIViewController {
    internal var isShowingBulletin: Bool {
        bulletinManager.currentBulletin.isSome
    }

    @available(iOS 13.0.0, *)
    @discardableResult
    func showBulletin<T>(_ content: ResultBulletin<T>, untilDismissed: Bool = false, overrideVc: UIViewController? = nil) async -> T {
        if let overrideVc {
            return await overrideVc.showBulletin(content, untilDismissed: untilDismissed)
        }

        bulletinManager.showBulletin(content)
        return await withCheckedContinuation { continuation in
            var dismissResult: T?
            content.onResult.subscribeOnce(with: self) { result in
                if untilDismissed { dismissResult = result }
                else { continuation.resume(returning: result) }
            }
            if untilDismissed {
                content.didDismiss.subscribeOnce(with: self) {
                    continuation.resume(returning: dismissResult ?? content.defaultResult)
                }
            }
        }
    }

    @discardableResult
    func showBulletin<B: PlainBulletin>(_ content: B) -> B {
        bulletinManager.showBulletin(content)
        return content
    }

    func showBulletin(_ content: Bulletin) {
        bulletinManager.showBulletin(content)
    }
    
    func share(_ items: [Any]?) {
        guard let items else { return }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    func share(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [NSItemProvider(object: image)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    func share(images: [UIImage]) {
        let activityViewController = UIActivityViewController(activityItems: images.map { NSItemProvider(object: $0) }, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    func openUrl(_ str: String, anchor: ContentBase?, inApp: Bool = true) {
        guard let url = URL(string: str) else { return }

        guard inApp, let anchor else {
            let app = UIApplication.shared
            if app.canOpenURL(url) { app.open(url) }
            return
        }

        let config = SFSafariViewController.Configuration()
        let safari = SFSafariViewController(url: url, configuration: config)
        safari.modalPresentationStyle = .popover
        if let popover = safari.popoverPresentationController {
            popover.sourceView = anchor.container
            popover.canOverlapSourceViewRect = true
            popover.permittedArrowDirections = .any
        }

        present(safari, animated: true)
    }

    func composeEmail(_ mailto: String, subject: String? = nil, body: String? = nil, anchor: ContentBase?) {
        guard let anchor, MFMailComposeViewController.canSendMail() else {
            openUrl("mailto:\(mailto)", anchor: nil, inApp: false)
            return
        }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([mailto])
        if let subject { mail.setSubject(subject) }
        if let body { mail.setMessageBody("\n\n---\n\(body)", isHTML: false) }
        mail.modalPresentationStyle = .popover
        if let popover = mail.popoverPresentationController {
            popover.sourceView = anchor.container
            popover.canOverlapSourceViewRect = true
            popover.permittedArrowDirections = .any
        }

        present(mail, animated: true)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
