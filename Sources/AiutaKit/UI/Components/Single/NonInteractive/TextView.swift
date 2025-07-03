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

    public var alignment: NSTextAlignment {
        get { view.textAlignment }
        set { view.textAlignment = newValue }
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

            view.linkTextAttributes = [.foregroundColor: color ?? font.color]
            let attributes = font.attributes(withAlignment: alignment, lineHeightSupport: isLineHeightMultipleEnabled)
            view.attributedText = Html(newValue).attributedString(withFont: font, color: color, attributes: attributes)

            if needLayout { updateParentLayout() }
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

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let attributedText else { return false }

        var touchedCharacterRange: NSRange?

        // Get the range of characters that were tapped
        // Using textContainer's hit test instead of layoutManager directly
        if let textPosition = closestPosition(to: point),
           let textRange = tokenizer.rangeEnclosingPosition(textPosition, with: .character, inDirection: UITextDirection(rawValue: 1)) {
            let startIndex = offset(from: beginningOfDocument, to: textRange.start)
            let endIndex = offset(from: beginningOfDocument, to: textRange.end)
            touchedCharacterRange = NSRange(location: startIndex, length: endIndex - startIndex)
        }

        if let touchedRange = touchedCharacterRange, touchedRange.location < attributedText.length {
            var effectiveRange = NSRange(location: 0, length: 0)
            let link = attributedText.attribute(.link, at: touchedRange.location, effectiveRange: &effectiveRange)

            return link != nil
        }

        return false
    }

    /** Alternative way uses layoutManager wich is switching UITextView to TextKit 1 compatibility mode
      override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
          // Only capture touches if the text contains links or some other interaction.
          let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
          let charIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
          if let attributedText, charIndex < attributedText.length,
             attributedText.attribute(.link, at: charIndex, effectiveRange: nil) != nil {
              return true
          }
          return false
      }
     **/
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
