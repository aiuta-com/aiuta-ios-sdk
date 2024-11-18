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

@_spi(Aiuta) open class TextView: Content<UnselectableTappableTextView> {
    public var onLink: Signal<String> {
        proxy.onLink
    }

    private enum ParseError: Error {
        case badData
    }

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

    public var isLineHeightMultipleEnabled = true {
        didSet { text = view.text }
    }

    public var isAnimatedChanges = false
    public var willLayoutParentOnChanges = true

    public var text: String? {
        get { view.text }
        set {
            let needLayout = view.text != newValue

            guard let font else {
                view.text = newValue
                font = ds.font.default
                return
            }

            guard let newValue else {
                view.text = newValue
                if needLayout { updateParentLayout() }
                return
            }

            var viewAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.kern: font.kern,
            ]

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = view.textAlignment
            if isLineHeightMultipleEnabled {
                paragraphStyle.lineHeightMultiple = font.lineHeightMultiple
            }
            viewAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            viewAttributes[NSAttributedString.Key.baselineOffset] = font.baselineOffset
            if let underline = font.underline {
                viewAttributes[NSAttributedString.Key.underlineStyle] = underline.rawValue
            }
            if let strikethrough = font.strikethrough {
                viewAttributes[NSAttributedString.Key.strikethroughStyle] = strikethrough.rawValue
            }

            view.linkTextAttributes = [.underlineStyle: 0, .underlineColor: UIColor.clear, .foregroundColor: color ?? font.color]
            view.attributedText = htmlAttributed(input: newValue, viewAttributes: viewAttributes)

            if needLayout { updateParentLayout() }
        }
    }

    private func htmlAttributed(input: String, viewAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        var html = input

        if let font {
            let color = (color ?? font.color).hexString ?? "black"
            html = "<span style=\"font-family: '\(font.family)-\(font.style.descriptor)', '-apple-system', 'HelveticaNeue'; font-weight: \(font.style.weight); font-size: \(font.size); color: \(color)\">\(html)</span>"
        }

        do {
            guard let data = html.data(using: String.Encoding.utf8) else {
                throw ParseError.badData
            }
            let result = try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
            let range = NSRange(location: 0, length: result.length)
            for key in viewAttributes.keys { result.removeAttribute(key, range: range) }
            result.addAttributes(viewAttributes, range: range)
            return result
        } catch {
            return NSMutableAttributedString(
                string: input,
                attributes: viewAttributes
            )
        }
    }

    private let proxy = TextViewProxy()

    override func setupInternal() {
        view.isEditable = false
        view.isSelectable = true
        view.delegate = proxy
        view.dataDetectorTypes = .link
        view.isScrollEnabled = false
        view.contentInset = .zero
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.backgroundColor = .clear
        view.gestureRecognizers?.filter {
            !($0 is UITapGestureRecognizer)
        }.forEach { gesture in
            view.removeGestureRecognizer(gesture)
        }
    }

    override func updateLayoutInternal() {
        view.sizeToFit()
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

    public convenience init(_ builder: (_ it: TextView, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

@_spi(Aiuta) public final class UnselectableTappableTextView: UITextView {
    override public var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 1 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        // https://stackoverflow.com/questions/36198299/uitextview-disable-selection-allow-links
        // https://stackoverflow.com/questions/46143868/xcode-9-uitextview-links-no-longer-clickable
        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
           // comparison value is used to distinguish between 0.12 (smallDelayRecognizer) and 0.5 (textSelectionForce and textLoupe)
           longPressGestureRecognizer.minimumPressDuration < 0.325 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        // gestureRecognizer.isEnabled = false
        return false
    }
}

private final class TextViewProxy: NSObject, UITextViewDelegate {
    let onLink = Signal<String>()

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        onLink.fire(URL.absoluteString)
        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}
