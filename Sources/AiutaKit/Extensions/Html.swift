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

@_spi(Aiuta) public final class Html: CustomStringConvertible {
    public enum Tags {
        case color(UIColor)
        case bold
        case italic
        case underline
        case link(String)
    }

    public var description: String { result }
    private var result: String

    public init(_ input: String, _ tags: Tags...) {
        result = input
        for tag in tags.reversed() {
            switch tag {
                case let .color(color):
                    if let hexString = color.hexString {
                        result = "<font color='#\(hexString)'>\(result)</font>"
                    }
                case let .link(url):
                    result = "<a href='\(url)'>\(result)</a>"
                case .bold:
                    result = "<b>\(result)</b>"
                case .underline:
                    result = "<u>\(result)</u>"
                case .italic:
                    result = "<i>\(result)</i>"
            }
        }
    }

    public static func br(_ count: Int = 1) -> String {
        Array(repeating: "<br/>", count: count).joined()
    }
}

@_spi(Aiuta) public extension Html {
    func attributedString(withFont font: FontRef?,
                          color: UIColor?,
                          attributes viewAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let input = result
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

            for key in viewAttributes.keys {
                if key == .underlineStyle { continue }
                result.removeAttribute(key, range: range)
            }
            result.addAttributes(viewAttributes, range: range)

            // Find all links and track if they contain or are inside underline tags
            let links = detectUnderlinedLinks(input)

            // Apply underline to links in the attributed string
            var linkIndex = 0
            result.enumerateAttribute(.link, in: range, options: []) { value, linkRange, _ in
                if value is URL, linkIndex < links.count {
                    if !links[linkIndex].shouldUnderline {
                        result.removeAttribute(.underlineStyle, range: linkRange)
                    }
                    linkIndex += 1
                }
            }

            return result
        } catch {
            return NSMutableAttributedString(
                string: input,
                attributes: viewAttributes
            )
        }
    }

    // Find all links and track if they contain or are inside underline tags
    private func detectUnderlinedLinks(_ input: String) -> [(url: String, shouldUnderline: Bool)] {
        var links = [(url: String, shouldUnderline: Bool)]()
        var tagStack = [String]()
        var currentLinkURL: String?
        var hasUnderlineInsideCurrentLink = false

        // Parse the HTML to track tag nesting
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = nil

        while !scanner.isAtEnd {
            if scanner.scanString("<") != nil {
                if let tag = scanner.scanUpToString(">") {
                    let trimmedTag = tag.trimmingCharacters(in: .whitespacesAndNewlines)

                    // Handle opening tags
                    if trimmedTag.hasPrefix("a ") || trimmedTag == "a" {
                        // Extract URL for a link - more flexible href matching
                        let hrefPattern = try? NSRegularExpression(pattern: "href\\s*=\\s*['\"]([^'\"]*)['\"]", options: [])
                        if let hrefPattern,
                           let match = hrefPattern.firstMatch(in: trimmedTag,
                                                              options: [],
                                                              range: NSRange(trimmedTag.startIndex..., in: trimmedTag)) {
                            let urlRange = match.range(at: 1)
                            if let urlRange = Range(urlRange, in: trimmedTag) {
                                currentLinkURL = String(trimmedTag[urlRange])
                            }
                        }

                        tagStack.append("a")
                        hasUnderlineInsideCurrentLink = false
                    } else if trimmedTag.hasPrefix("u") && !trimmedTag.hasPrefix("ul") {
                        tagStack.append("u")

                        // If we're inside a link, mark that we found an underline inside it
                        if tagStack.contains("a") {
                            hasUnderlineInsideCurrentLink = true
                        }
                    } else if trimmedTag == "/a" {
                        // End of link - store if it had underline inside or was inside underline
                        if let url = currentLinkURL {
                            // A link should be underlined if either:
                            // 1. It has an underline tag inside it, or
                            // 2. It's inside an underline tag (check if 'u' exists in stack before 'a')
                            let isInsideUnderline = tagStack.firstIndex(of: "u") ?? Int.max < tagStack.firstIndex(of: "a") ?? Int.max
                            links.append((url: url, shouldUnderline: hasUnderlineInsideCurrentLink || isInsideUnderline))
                        }

                        // Remove the 'a' tag from stack
                        if let index = tagStack.lastIndex(of: "a") {
                            tagStack.remove(at: index)
                        }
                        currentLinkURL = nil
                    } else if trimmedTag == "/u" {
                        // Remove the 'u' tag from stack
                        if let index = tagStack.lastIndex(of: "u") {
                            tagStack.remove(at: index)
                        }
                    }
                }
                _ = scanner.scanString(">")
            } else {
                _ = scanner.scanUpToString("<")
            }
        }

        return links
    }
}

private extension Html {
    enum ParseError: Error {
        case badData
    }
}
