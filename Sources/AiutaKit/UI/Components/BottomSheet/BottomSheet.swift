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

import UIKit

@_spi(Aiuta) open class BottomSheet: Scroll {
    public let didPullUp = Signal<Void>()
    public let didPullDown = Signal<Void>()

    public let substrate = BottomSheetSubstrate()

    private var scrollOffset: CGFloat = 0 {
        didSet { updateLayoutInternal() }
    }

    private var isPulledDown = false {
        didSet {
            guard oldValue != isPulledDown else { return }
            if isPulledDown {
                didPullDown.fire()
                isPulledUp = false
                if #available(iOS 13.0, *) {
                    haptic(impact: .soft)
                }
            }
        }
    }

    private var isPulledUp = false {
        didSet {
            guard oldValue != isPulledUp else { return }
            if isPulledUp {
                didPullUp.fire()
                isPulledDown = false
                if #available(iOS 13.0, *) {
                    haptic(impact: .soft)
                }
            }
        }
    }

    private var isKeyboardVisible = false {
        didSet {
            guard oldValue != isKeyboardVisible else { return }
            isPulledUp = isKeyboardVisible
            isPulledDown = !isKeyboardVisible
        }
    }

    override open func setup() {
        substrate.sendToBack()

        scrollView.didChangeOffset.subscribe(with: self) { [unowned self] offset, _ in
            scrollOffset = offset
            if offset < -70 { isPulledDown = true }
            if offset > 1 { isPulledUp = true }
        }
    }

    override func updateLayoutInternal() {
        let topInset: CGFloat = layout.screen.height

        isKeyboardVisible = layout.keyboard.isVisible
        if layout.keyboard.isVisible {
            scrollView.contentInset = .init(top: topInset + 24, bottom: layout.keyboard.height)
        } else {
            scrollView.contentInset = .init(top: topInset + 24, bottom: layout.safe.insets.bottom)
        }

        layout.make { make in
            make.height = min(scrollView.contentSize.height + scrollView.contentInset.verticalInsetsSum - topInset + 16,
                              layout.screen.height - layout.safe.insets.top)
            if !layout.keyboard.isVisible {
                make.height = min(make.height, layout.screen.height * 0.5 - layout.safe.insets.top)
            }
            make.width = min(700, layout.boundary.width)
            make.bottom = 0
            make.centerX = 0
        }

        scrollView.layout.make { make in
            make.width = layout.width
            make.height = layout.height + topInset
            make.top = -topInset
        }

        substrate.layout.make { make in
            make.height = layout.height + layout.screen.height
            make.width = layout.width
            make.top = -scrollOffset
        }
    }
}

@_spi(Aiuta) public final class BottomSheetSubstrate: Plane {
    public let stroke = Stroke { it, _ in
        it.color = 0xC5C5C5FF.uiColor
    }

    override public func setup() {
        appearance.make { make in
            make.cornerRadius = 24
            if #available(iOS 13.0, *) {
                make.cornerCurve = .continuous
            }
            make.backgroundColor = ds.kit.item
        }
    }

    override public func updateLayout() {
        stroke.layout.make { make in
            make.size = .init(width: 30, height: 3)
            make.radius = 1.5
            make.centerX = 0
            make.top = 8
        }
    }
}
