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

@_spi(Aiuta) open class Label: Content<UILabel> {
    public var font: FontRef? {
        didSet {
            guard let font else { return }
            view.font = font.uiFont()
            color = font.color
            text = view.text
        }
    }

    public var color: UIColor? {
        get { view.textColor }
        set { view.textColor = newValue }
    }

    public var text: String? {
        get { view.text }
        set {
            let needLayout = view.text != newValue

            guard let font else {
                view.text = newValue
                font = ds.kit.font
                return
            }

            guard let newValue else {
                view.text = newValue
                if needLayout { updateParentLayout() }
                return
            }

            let attributes = font.attributes(withAlignment: view.textAlignment,
                                             lineBreakMode: view.lineBreakMode,
                                             lineHeightSupport: isLineHeightMultipleEnabled && isMultiline)

            let attributedText: NSAttributedString
            if isHtml {
                attributedText = Html(newValue).attributedString(withFont: font, color: color, attributes: attributes)
            } else {
                attributedText = NSMutableAttributedString(string: newValue, attributes: attributes)
            }

            if let leadingAttachment {
                let attachmentString = NSAttributedString(attachment: leadingAttachment)
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                completeText.append(NSAttributedString(string: " "))
                completeText.append(attributedText)
                view.attributedText = completeText
            } else {
                view.attributedText = attributedText
            }

            if needLayout { updateParentLayout() }
        }
    }

    public var hasText: Bool {
        guard let text else { return false }
        return !text.isEmpty
    }

    public var isLineHeightMultipleEnabled = true {
        didSet { text = view.text }
    }

    public var isAnimatedChanges = false

    public var willLayoutParentOnChanges = true

    public var isHtml: Bool = false

    public var isMultiline: Bool {
        get { view.numberOfLines != 1 }
        set {
            view.numberOfLines = newValue ? 0 : 1
            view.lineBreakMode = newValue ? .byWordWrapping : .byTruncatingTail
        }
    }

    public var lineBreak: NSLineBreakMode {
        get { view.lineBreakMode }
        set { view.lineBreakMode = newValue }
    }

    public var alignment: NSTextAlignment {
        get { view.textAlignment }
        set { view.textAlignment = newValue }
    }

    public var minScale: CGFloat {
        get { view.adjustsFontSizeToFitWidth ? view.minimumScaleFactor : 1 }
        set {
            view.minimumScaleFactor = clamp(newValue, min: 0, max: 1)
            view.adjustsFontSizeToFitWidth = view.minimumScaleFactor < 1
        }
    }

    var leadingAttachment: NSTextAttachment? {
        didSet { text = view.text }
    }

    public func attach(_ image: UIImage?, bounds: CGRect) {
        guard let image else { return }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        leadingAttachment = attachment
    }

    public convenience init(_ builder: (_ it: Label, _ ds: DesignSystem) -> Void) {
        self.init()
        view.isUserInteractionEnabled = false
        builder(self, ds)
    }

    @discardableResult
    public convenience init(view: UILabel, _ builder: (_ it: Label, _ ds: DesignSystem) -> Void) {
        self.init(view: view)
        view.isUserInteractionEnabled = false
        builder(self, ds)
    }

    private func updateParentLayout() {
        guard willLayoutParentOnChanges else { return }
        if isAnimatedChanges {
            animations.animate { [weak self] in
                self?.parent?.updateLayoutRecursive()
            }
        } else {
            parent?.updateLayoutRecursive()
        }
    }
}
