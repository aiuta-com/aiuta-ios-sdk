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
final class SplashViewController: ViewController<SplashView> {
    @injected private var session: SessionModel

    override func setup() {
        ui.closeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.startButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            replace(with: OnBoardingViewController(), backstack: self)
        }

        session.delegate?.aiuta(eventOccurred: .page(page: page, product: session.activeSku))
    }

    override func whenPopback() {
        session.delegate?.aiuta(eventOccurred: .page(page: page, product: session.activeSku))
    }
}

@available(iOS 13.0.0, *)
extension SplashViewController: PageRepresentable {
    var page: Aiuta.Event.Page { .welcome }
    var isSafeToDismiss: Bool { true }
}
