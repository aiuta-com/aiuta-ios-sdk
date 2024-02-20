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

import AiutaKit
import UIKit

final class AiutaOnboardingViewController: ViewController<AiutaOnboardingView> {
    private var forwardVc: UIViewController?

    convenience init(forward vc: UIViewController) {
        self.init()
        forwardVc = vc
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.footer.go.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let forwardVc else { return }
            replace(with: forwardVc)
        }

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }
}
