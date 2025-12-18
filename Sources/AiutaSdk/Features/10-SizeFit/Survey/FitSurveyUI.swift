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
    let topBlur = Blur { it, _ in
        it.style = .light
    }

    let navBar = NavBar { it, ds in
        if ds.styles.preferCloseButtonOnTheRight {
            it.style = .actionTitleClose
        } else {
            it.style = .closeTitleAction
        }
    }

    let gradient = Gradient { it, _ in
        it.colorStops = [
            .init(UIColor(red: 0.421, green: 0.907, blue: 0.687, alpha: 1), 0.34),
            .init(UIColor(red: 0.272, green: 0.895, blue: 0.917, alpha: 1), 1),
        ]
        it.direction = .horizontal
    }

    let icon = Image { it, ds in
        it.isAutoSize = false
        it.source = ds.icons.sizeFit24
        it.tint = ds.colors.primary
    }

    let title = Label { it, ds in
        it.font = ds.fonts.titleL
        it.color = ds.colors.primary
        it.text = "Find your size"
    }

    @scrollable
    var gender = GenderSelector()

    @scrollable
    var age = Field { it, _ in
        it.hint.text = "Age"
    }

    @scrollable
    var height = Field { it, _ in
        it.hint.text = "Height"
        it.measurment.text = "KG"
    }

    @scrollable
    var weight = Field { it, _ in
        it.hint.text = "Weight"
        it.measurment.text = "CM"
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
        gradient.layout.make { make in
            make.circle = 52
            make.centerX = 0
            make.top = navBar.layout.bottomPin + 20
        }

        icon.layout.make { make in
            make.square = 26
            make.center = gradient.layout.center
        }

        title.layout.make { make in
            make.centerX = 0
            make.top = gradient.layout.bottomPin + 20
        }

        topBlur.layout.make { make in
            make.leftRight = 0
            make.height = title.layout.bottomPin + 16
        }

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
            scrollView.contentInset = .init(top: title.layout.bottomPin + 32,
                                            bottom: max(layout.safe.insets.bottom + 82, layout.keyboard.height + 16))
        }
    }
}
