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

    public var highlights: [String]?
    public var caseHighlights: [String]?
    public var highlightColor: UIColor?

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
            paragraphStyle.lineBreakMode = view.lineBreakMode
            viewAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            viewAttributes[NSAttributedString.Key.baselineOffset] = font.baselineOffset
            if let underline = font.underline {
                viewAttributes[NSAttributedString.Key.underlineStyle] = underline.rawValue
            }
            if let strikethrough = font.strikethrough {
                viewAttributes[NSAttributedString.Key.strikethroughStyle] = strikethrough.rawValue
            }

            if let highlights, !highlights.isEmpty {
                var highlightAttributes = viewAttributes
                highlightAttributes[NSAttributedString.Key.foregroundColor] = highlightColor ?? ds.color.highlight
                view.attributedText = colorize(input: newValue, highlights: highlights, viewAttributes: viewAttributes, highlightAttributes: highlightAttributes)
            } else if let caseHighlights, !caseHighlights.isEmpty {
                var highlightAttributes = viewAttributes
                highlightAttributes[NSAttributedString.Key.foregroundColor] = highlightColor ?? ds.color.highlight
                view.attributedText = caseColorize(input: newValue, highlights: caseHighlights, viewAttributes: viewAttributes, highlightAttributes: highlightAttributes)
            } else {
                view.attributedText = NSMutableAttributedString(
                    string: newValue,
                    attributes: viewAttributes
                )
            }

            if needLayout { updateParentLayout() }
        }
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

    private func caseColorize(input: String, highlights: [String], viewAttributes: [NSAttributedString.Key: Any], highlightAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        guard let hl = highlights.first else { return NSMutableAttributedString(string: input, attributes: viewAttributes) }
        let result = NSMutableAttributedString(string: "", attributes: viewAttributes)
        let parts = input.components(separatedBy: hl)
        let nextHighlights = Array(highlights.dropFirst(1))
        if let left = parts.first, !left.isEmpty {
            result.append(caseColorize(input: left, highlights: nextHighlights, viewAttributes: viewAttributes, highlightAttributes: highlightAttributes))
        }
        if !parts.isEmpty {
            result.append(NSMutableAttributedString(string: hl, attributes: highlightAttributes))
        }
        if let right = parts.second, !right.isEmpty {
            result.append(caseColorize(input: right, highlights: nextHighlights, viewAttributes: viewAttributes, highlightAttributes: highlightAttributes))
        }
        return result
    }

    private func colorize(input: String, highlights: [String], viewAttributes: [NSAttributedString.Key: Any], highlightAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "", attributes: viewAttributes)
        let parts = splitInput(input: input, highlights: highlights)

        parts.forEach { sub in
            if highlights.contains(sub.lowercased()) {
                result.append(NSMutableAttributedString(string: sub, attributes: highlightAttributes))
            } else {
                result.append(NSMutableAttributedString(string: sub, attributes: viewAttributes))
            }
        }
        return result
    }

    private func splitInput(input: String, highlights: [String]) -> [String] {
        if highlights.isEmpty { return [input] }

        var result = [String]()

        for i in 0 ..< highlights.count {
            let highlight = highlights[i]

            if highlight.count > input.count { continue }

            if input.lowercased() == highlight.lowercased() { return [input] }

            if !input.contains(highlight) { continue }

            let caseInsensitiveSplit = input.caseInsensitiveSplit(separator: highlight)
            if caseInsensitiveSplit.count <= 1 { continue }

            for j in 0 ..< caseInsensitiveSplit.count {
                let part = caseInsensitiveSplit[j]

                if part.lowercased() == highlight.lowercased() {
                    result.append(part)
                } else {
                    let subHighlights = Array(highlights.dropFirst(i + 1))
                    result.append(contentsOf: splitInput(input: part, highlights: subHighlights))
                }
            }
            return result
        }

        if result.isEmpty { return [input] }
        return result
    }

    public var isLineHeightMultipleEnabled = true {
        didSet { text = view.text }
    }

    public var isAnimatedChanges = false
    public var willLayoutParentOnChanges = true

    public var hasText: Bool {
        guard let text else { return false }
        return !text.isEmpty
    }

    public var isMultiline: Bool {
        get { view.numberOfLines != 0 }
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
}

private extension String {
    func caseInsensitiveSplit(separator: String) -> [String] {
        if separator.isEmpty {
            return [self]
        }
        let pattern = NSRegularExpression.escapedPattern(for: separator)
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: self, options: [], range: NSRange(0 ..< utf16.count))
        var ranges = [NSRange]()
        var pointer: Int = 0

        for i in 0 ..< matches.count {
            let match = matches[i]
            let start = pointer
            let end = match.range.location
            if end > start {
                ranges.append(NSRange(location: start, length: end - start))
            }

            ranges.append(match.range)
            pointer = end + match.range.length

            if i == matches.count - 1 {
                let start = pointer
                let end = utf16.count
                if end > start {
                    ranges.append(NSRange(location: pointer, length: utf16.count - pointer))
                }
            }
        }
        if matches.isEmpty { return [self] }
        return ranges.map { String(self[Range($0, in: self)!]) }
    }
}
