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
import Resolver
import UIKit

@available(iOS 13.0, *)
final class AiutaProcessingController: ComponentController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel

    override func setup() {
        ui.errorSnackbar.bar.gestures.onSwipe(.down, with: self) { [unowned self] _ in
            ui.errorSnackbar.isVisible = false
        }

        ui.errorSnackbar.bar.gestures.onTap(with: self) { [unowned self] _ in
            ui.errorSnackbar.isVisible = false
        }

        ui.errorSnackbar.bar.close.onTouchUpInside.subscribe(with: self) { [unowned self] in
            ui.errorSnackbar.isVisible = false
        }

        model.onError.subscribe(with: self) { [unowned self] error in
            showError(error)
        }

        model.onChangeState.subscribe(with: self) { [unowned self] state in
            switch state {
                case let .processing(proc):
                    switch proc {
                        case .uploadingImage: ui.processingLoader.status.label.text = "Uploading image"
                        case .generatingOutfit: ui.processingLoader.status.label.text = "Generating outfit"
                        case .scanningBody: ui.processingLoader.status.label.text = "Scanning your body"
                        case .failed: ui.processingLoader.status.label.text = "Something went wrong"
                    }
                default: break
            }
        }
    }

    func showError(_ text: String = "Something went wrong.\nPlease try again later") {
        ui.errorSnackbar.bar.label.text = text
        ui.errorSnackbar.isVisible = true
    }
}
