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

@_spi(Aiuta) open class LabelButton: Content<TouchView> {
    public var onTouchDown: Signal<Void> { view.onTouchDown }
    public var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    public var onLongTouch: Signal<Void> { view.onLongTouch }

    public let label = Label { it, _ in
        it.isLineHeightMultipleEnabled = false
    }

    public var labelInsets = UIEdgeInsets(horizontal: 16, vertical: 9)

    public var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    public var style: StyleRef? {
        didSet {
            font = style?.font
            label.color = style?.foregroundColor
            view.backgroundColor = style?.backgroundColor
            view.borderColor = style?.foregroundColor
            view.borderWidth = style?.borderWidth ?? 0
            view.cornerRadius = style?.cornerRadius ?? 0
        }
    }

    public var font: FontRef? {
        get { label.font }
        set { label.font = newValue }
    }

    public var color: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }

    public var customLayout = false

    override func sizeToFit() {
        guard !customLayout else { return }

        label.appearance.make { make in
            make.sizeToFit()
        }

        layout.make { make in
            make.size = label.layout.size + labelInsets
            if let designedHeight = style?.designedHeight {
                make.height = designedHeight
            }
        }
    }

    override open func updateLayout() {
        guard !customLayout else { return }
        label.layout.make { make in
            make.center = .zero
        }
    }

    public convenience init(_ builder: (_ it: LabelButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
