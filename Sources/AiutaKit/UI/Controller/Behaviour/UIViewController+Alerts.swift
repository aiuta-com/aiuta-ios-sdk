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
import Resolver
import SafariServices
import UIKit

@_spi(Aiuta) public extension UIViewController {
    func showAlert(message: String,
                   preferredStyle style: UIAlertController.Style = .alert,
                   builder: (AlertBuilder) -> Void) {
        showAlert(title: nil, message: message, preferredStyle: style, builder: builder)
    }

    func showAlert(title: String,
                   preferredStyle style: UIAlertController.Style = .alert,
                   builder: (AlertBuilder) -> Void) {
        showAlert(title: title, message: nil, preferredStyle: style, builder: builder)
    }

    func showAlert(title: String?,
                   message: String?,
                   preferredStyle style: UIAlertController.Style = .alert,
                   builder: (AlertBuilder) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        builder(AlertBuilder(alert: alert))
        present(alert, animated: true)
    }
}

@_spi(Aiuta) public final class AlertBuilder {
    let alert: UIAlertController

    init(alert: UIAlertController) {
        self.alert = alert
    }

    @discardableResult
    public func addAction(title: String?, style: UIAlertAction.Style) -> Signal<Void> {
        let signal = Signal<Void>()
        let action = UIAlertAction(title: title, style: style) { [signal] _ in
            signal.fire()
        }
        alert.addAction(action)
        return signal
    }
}
