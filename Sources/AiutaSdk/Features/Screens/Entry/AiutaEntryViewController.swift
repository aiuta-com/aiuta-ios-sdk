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

@available(iOS 13.0.0, *)
final class AiutaEntryViewController: ViewController<AiutaEntryView> {
    private var session: Aiuta.TryOnSession?

    convenience init(session: Aiuta.TryOnSession) {
        self.init()
        self.session = session
    }

    override func prepare() {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left),
                                            dismissing: .pull(direction: .right))
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            dismiss()
        }
    }

    override func start() async {
        guard let session else {
            dismiss()
            return
        }
        let tryOn = AiutaTryOnViewController(session: session)
        await asleep(.oneSecond)
        if tryOn.hasUploads {
            replace(with: tryOn)
        } else {
            replace(with: AiutaOnboardingViewController(forward: tryOn))
        }
    }
}
