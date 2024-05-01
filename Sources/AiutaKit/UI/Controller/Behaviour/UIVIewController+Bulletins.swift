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

import MessageUI
import Photos
import PhotosUI
import SafariServices
import UIKit

@_spi(Aiuta) public extension UIViewController {
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

@_spi(Aiuta) extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
