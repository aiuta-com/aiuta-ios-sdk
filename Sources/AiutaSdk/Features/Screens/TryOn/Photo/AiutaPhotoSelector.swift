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
import Resolver
import UIKit

final class AiutaPhotoSelector: Plane {
    @Injected private var heroic: Heroic
    let onChangePhoto = Signal<Void>()

    var inputs: Aiuta.Inputs? {
        didSet {
            hasInputs = inputs.isSome
            if #available(iOS 13.0, *) {
                Task {
                    await heroic.completeTransition()
                    preview.inputs = inputs
                }
            } else {
                preview.inputs = inputs
            }
        }
    }

    private var hasInputs = false {
        didSet {
            guard oldValue != hasInputs else { return }
            newPhotoButton.view.isVisible = !hasInputs
            changePhotoButton.view.isVisible = hasInputs
        }
    }

    private let preview = AiutaCollageView()

    let newPhotoButton = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.accent
        it.text = L.imageSelectorUploadButton
    }

    let changePhotoButton = ChangePhotoButton { it, _ in
        it.view.isVisible = false
    }

    override func setup() {
        view.backgroundColor = ds.color.item

        newPhotoButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            onChangePhoto.fire()
        }

        changePhotoButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            onChangePhoto.fire()
        }
    }

    override func updateLayout() {
        layout.make { make in
            make.radius = 24
        }

        preview.layout.make { make in
            make.inset = 0
        }

        newPhotoButton.layout.make { make in
            make.width = 200
            make.height = 42
            make.radius = 8
            make.bottom = 20
            make.centerX = 0
        }

        changePhotoButton.layout.make { make in
            make.bottom = 24
            make.centerX = 0
        }
    }
}

extension AiutaPhotoSelector {
    final class ChangePhotoButton: PlainButton {
        let blur = Blur { it, _ in
            it.style = .extraLight
            it.intensity = 0.5
        }

        let label = Label { it, ds in
            it.font = ds.font.secondary
            it.color = .black
            it.text = L.imageSelectorChangeButton
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 200
                make.height = 40
                make.radius = 8
            }

            blur.layout.make { make in
                make.inset = 0
            }

            label.layout.make { make in
                make.center = .zero
            }
        }
    }
}
