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
import UIKit

extension UIViewController {
    func popoverOrCover(_ vc: UIViewController) {
        @injected var config: Aiuta.Configuration
        if config.appearance.presentationStyle.isFullScreen {
            cover(vc)
        } else {
            (navigationController ?? self).popover(vc)
        }
    }

    func cover(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        (navigationController ?? self).present(vc, animated: true)
    }

    func dismissAll(completion: (() -> Void)? = nil) {
        if let navigator = navigationController as? SdkNavigator {
            navigator.sdkWillDismiss()
            navigator.dismiss(animated: true) {
                navigator.sdkDidDismiss()
                completion?()
            }
        } else {
            dismiss(animated: true, completion: completion)
        }
    }
}
