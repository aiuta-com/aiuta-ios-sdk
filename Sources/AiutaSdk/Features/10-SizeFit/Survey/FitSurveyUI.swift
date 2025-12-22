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

final class FitSurveyUI: Scroll {
    let navBar = NavBar { it, ds in
        if ds.styles.preferCloseButtonOnTheRight {
            it.style = .actionTitleClose
        } else {
            it.style = .closeTitleAction
        }
        it.blur.view.isVisible = true

        if #available(iOS 26, *) {
            it.blur.glass = .regular
        } else {
            it.blur.intensity = 0.5
        }

        it.blur.softEdge = .bottom
        it.blur.softness = 0.4
    }

    @scrollable
    var header = Header()

    @scrollable
    var gender = GenderSelector()

    @scrollable
    var age = Field { it, _ in
        it.hint.text = "Age"
    }

    @scrollable
    var height = Field { it, _ in
        it.hint.text = "Height"
        it.measurment.text = "CM"
    }

    @scrollable
    var weight = Field { it, _ in
        it.hint.text = "Weight"
        it.measurment.text = "KG"
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

    let findSize = LabelButton { it, ds in
        it.font = ds.fonts.buttonM
        it.color = ds.colors.brand
        it.label.color = ds.colors.onDark
        it.label.minScale = 0.5
        it.text = "Find your size"
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

    var fields: [Field] { scrollView.findChildren() }

    let errorSnackbar = Snackbar<ErrorSnackbar>()

    private var loadingToken = AutoCancellationToken()
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }

            scrollView.view.isUserInteractionEnabled = !isLoading
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
        fields.forEach { $0.resign() }
        animations.animate { [self] in
            updateLayoutRecursive()
        }
    }

    override func setup() {
        scrollView.itemSpace = 12
        scrollView.flexibleWidth = false

        scrollView.gestures.onTap(cancelsTouchesInView: false, with: self) { [unowned self] tap in
            guard tap.state == .ended else { return }
            let point = tap.location(in: scrollView.view)

            for v in fields {
                let p = scrollView.view.convert(point, to: v.view)
                if v.view.bounds.contains(p) { return }
            }

            hideKeyboard()
        }

        keyboardWillHide.subscribe(with: self) { [unowned self] _ in
            scrollView.scrollToTop()
        }
    }

    override func updateLayout() {
        disclaimer.layout.make { make in
            make.leftRight = 16
            make.bottom = layout.safe.insets.bottom + 16
        }

        findSize.layout.make { make in
            make.height = 50
            make.leftRight = 16
            make.bottom = disclaimer.layout.topPin + 24
            make.shape = ds.shapes.buttonM
        }

        activity.layout.make { make in
            make.center = findSize.layout.center
        }

        scrollView.keepOffset {
            scrollView.contentInset = .init(top: navBar.layout.bottomPin,
                                            bottom: max(findSize.layout.topPin, layout.keyboard.height) + 16)
        }

        blur.layout.make { make in
            make.leftRight = 0
            make.top = findSize.layout.top - 16
            make.bottom = -16
        }
    }
}
