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

final class NavBar: Plane {
    let onBack = Signal<Void>()
    let onClose = Signal<Void>()
    let onAction = Signal<Void>()

    var style: LayoutStyle = .backTitleAction { didSet { updateStyle() } }
    var backStyle: ButtonStyle? = .default { didSet { updateStyle() } }
    var closeStyle: ButtonStyle? = .default { didSet { updateStyle() } }
    var actionStyle: ButtonStyle? { didSet { updateStyle() } }
    var title: String? { didSet { titleLabel.text = title } }
    var isActionAvailable = false { didSet { updateStyle() } }

    private let leftButton = NavButton()
    private let rightButton = NavButton()
    private let titleLabel = Label { it, ds in
        it.font = ds.fonts.pageTitle
        it.color = ds.colors.primary
        it.alignment = .center
        it.isHtml = true
        it.minScale = 0.8
    }

    private func updateStyle() {
        switch style {
            case .backTitleAction:
                leftButton.style = backStyle
                rightButton.style = isActionAvailable ? actionStyle : nil
            case .closeTitleAction:
                leftButton.style = closeStyle
                rightButton.style = isActionAvailable ? actionStyle : nil
            case .actionTitleClose:
                leftButton.style = isActionAvailable ? actionStyle : nil
                rightButton.style = closeStyle
            case .backTitleClose:
                leftButton.style = backStyle
                rightButton.style = closeStyle
        }
        updateLayout()
    }

    override func setup() {
        leftButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            switch style {
                case .backTitleAction: onBack.fire()
                case .closeTitleAction: onClose.fire()
                case .actionTitleClose: onAction.fire()
                case .backTitleClose: onBack.fire()
            }
        }

        rightButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            switch style {
                case .backTitleAction: onAction.fire()
                case .closeTitleAction: onAction.fire()
                case .actionTitleClose: onClose.fire()
                case .backTitleClose: onClose.fire()
            }
        }

        if case .default = backStyle {
            backStyle = .icon(ds.icons.back24)
        }

        if case .default = closeStyle {
            closeStyle = .icon(ds.icons.close24)
        }

        updateStyle()
    }

    override func updateLayout() {
        layout.make { make in
            if ds.styles.isFullScreen {
                make.top = layout.safe.insets.top - 8
            } else {
                make.top = 0
            }
            make.leftRight = 0
            make.height = 52
        }

        leftButton.layout.make { make in
            make.left = 0
        }

        rightButton.layout.make { make in
            make.right = 0
        }

        titleLabel.layout.make { make in
            make.leftRight = max(leftButton.layout.rightPin, rightButton.layout.leftPin)
            make.centerY = 0
        }
    }

    convenience init(_ builder: (_ it: NavBar, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

extension NavBar {
    enum LayoutStyle {
        case backTitleAction
        case closeTitleAction
        case actionTitleClose
        case backTitleClose
    }

    enum ButtonStyle {
        case icon(UIImage?)
        case label(String)
        case `default`
    }
}

// MARK: - Navigation button

private final class NavButton: PlainButton {
    var style: NavBar.ButtonStyle? {
        didSet {
            switch style {
                case .default:
                    break
                case let .icon(ref):
                    icon.image = ref
                    title.text = nil
                    icon.view.isVisible = true
                    title.view.isVisible = false
                    view.isVisible = true
                case let .label(string):
                    icon.image = nil
                    title.text = string
                    icon.view.isVisible = false
                    title.view.isVisible = true
                    view.isVisible = true
                case nil:
                    icon.image = nil
                    title.text = nil
                    icon.view.isVisible = false
                    title.view.isVisible = false
                    view.isVisible = false
            }
        }
    }

    private let icon = Image { it, ds in
        it.isAutoSize = false
        it.tint = ds.colors.primary
        it.view.isVisible = false
    }

    private let title = Label { it, ds in
        it.font = ds.fonts.pageTitle
        it.color = ds.colors.primary
        it.view.isVisible = false
    }

    override func setup() {
        view.isVisible = false
    }

    override func updateLayout() {
        layout.make { make in
            make.height = layout.boundary.height
        }

        switch style {
            case .icon, .default:
                icon.layout.make { make in
                    make.square = 24
                    make.left = 12
                    make.centerY = 0
                }
                layout.make { make in
                    make.width = icon.layout.rightPin + icon.layout.left
                }
            case .label:
                title.layout.make { make in
                    make.left = 20
                    make.centerY = 0
                }
                layout.make { make in
                    make.width = title.layout.rightPin + title.layout.left
                }
            case nil:
                layout.make { make in
                    make.width = 0
                }
        }
    }
}
