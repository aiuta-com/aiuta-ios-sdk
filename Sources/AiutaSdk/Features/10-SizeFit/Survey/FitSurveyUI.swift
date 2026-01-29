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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

final class FitSurveyUI: Plane {
    enum Step: Equatable {
        case main, shape, bra
    }

    var step: Step = .main {
        didSet {
            guard oldValue != step else { return }
            switch step {
                case .main:
                    navBar.style = .actionTitleClose
                    findSize.text = "Next"
                    progress.value = 0
                case .shape:
                    navBar.style = .backTitleClose
                    findSize.text = main.gender.value == .female ? "Next" : "Find my size"
                    progress.value = main.gender.value == .female ? 0.5 : 1
                case .bra:
                    navBar.style = .backTitleClose
                    findSize.text = "Find my size"
                    progress.value = 1
            }
            findSize.animations.transition(.transitionCrossDissolve, duration: .thirdOfSecond)
        }
    }

    let main = Main()
    let shape = Shape()
    let bra = Bra()

    let navBar = NavBar { it, _ in
        it.style = .actionTitleClose
        it.blur.view.isVisible = true

        if #available(iOS 26, *) {
            it.blur.glass = .regular
        } else {
            it.blur.intensity = 0.5
        }

        it.blur.softEdge = .bottom
        it.blur.softness = 0.4
    }

    let blur = Blur { it, ds in
        if #available(iOS 26, *) {
            it.glass = .regular
        } else {
            it.style = ds.colors.scheme.safeBlurStyle
            it.intensity = 0.5
        }
        it.softEdge = .top
        it.softOffset = 0.05
    }

    let progress = Progress()

    let findSize = LabelButton { it, ds in
        it.font = ds.fonts.buttonM
        it.color = ds.colors.brand
        it.label.color = ds.colors.onDark
        it.label.minScale = 0.5
        it.text = "Next"
    }

    let activity = Spinner { it, ds in
        it.style = .medium
        it.color = ds.colors.onDark
        it.isSpinning = false
    }

    let disclaimer = Label { it, ds in
        it.isHtml = true
        it.isMultiline = true
        it.alignment = .center
        it.font = ds.fonts.disclaimer
        it.color = ds.colors.secondary
        it.text = "Your data will be processed under our \(Html("Privacy Policy", .underline))"
    }

    let errorSnackbar = Snackbar<ErrorSnackbar>()

    private var loadingToken = AutoCancellationToken()
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }

            main.scrollView.view.isUserInteractionEnabled = !isLoading
            shape.scrollView.view.isUserInteractionEnabled = !isLoading
            bra.scrollView.view.isUserInteractionEnabled = !isLoading
            findSize.view.isUserInteractionEnabled = !isLoading

            if isLoading {
                errorSnackbar.isVisible = false
            }

            loadingToken << delay(isLoading ? .quarterOfSecond : .moment) { [self] in
                findSize.label.animations.visibleTo(!isLoading)
                activity.isSpinning = isLoading
            }
        }
    }

    @notification(UIResponder.keyboardWillHideNotification)
    private var keyboardWillHide: Signal<Notification>

    func hideKeyboard() {
        main.fields.forEach { $0.resign() }
        animations.animate { [self] in
            updateLayoutRecursive()
        }
    }

    override func updateLayout() {
        progress.layout.make { make in
            make.center = navBar.layout.center
        }

        findSize.layout.make { make in
            make.height = 50
            make.leftRight = 16
            make.bottom = layout.safe.insets.bottom + 16
            make.shape = ds.shapes.buttonM
        }

        disclaimer.layout.make { make in
            make.width = layout.width - 32
            make.bottom = findSize.layout.topPin + 20
        }

        activity.layout.make { make in
            make.center = findSize.layout.center
        }

        main.insets = .init(top: navBar.layout.bottomPin, bottom: findSize.layout.topPin)
        shape.insets = main.insets
        bra.insets = main.insets

        main.layout.make { make in
            if step == .main {
                make.left = 0
            } else {
                make.right = layout.width
            }
        }

        disclaimer.layout.make { make in
            make.left = main.layout.left + 16
        }

        shape.layout.make { make in
            switch step {
                case .main:
                    make.left = layout.width
                case .shape:
                    make.left = 0
                case .bra:
                    make.right = layout.width
            }
        }

        bra.layout.make { make in
            if step == .bra {
                make.left = 0
            } else {
                make.left = layout.width
            }
        }

        blur.layout.make { make in
            make.leftRight = 0
            make.top = findSize.layout.top - 16
            make.bottom = -16
        }
    }
}
