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

import Foundation
import UIKit

extension Aiuta.Configuration {
    /// Represents an icon source used in Aiuta SDK configuration.
    ///
    /// Supported representations:
    /// - `.url(URL, renderingMode:)` — load an image from a URL with a specified `UIImage.RenderingMode`
    /// - `.image(UIImage)`           — use a concrete `UIImage` instance
    ///
    /// Conforms to `ExpressibleByStringLiteral` so you can write a string literal (e.g. a URL string)
    /// directly where an `Icon` is expected.
    public enum Icon {
        /// A remote or local image referenced by URL with an explicit rendering mode.
        case url(URL, renderingMode: UIImage.RenderingMode)
        /// A concrete `UIImage` used as-is.
        case image(UIImage)
    }

    /// Represents an image source used in Aiuta SDK configuration.
    ///
    /// Supported representations:
    /// - `.url(URL)`   — load an image from a URL
    /// - `.image(UIImage)` — use a concrete `UIImage` instance
    ///
    /// Conforms to `ExpressibleByStringLiteral` so you can write a string literal (e.g. a URL string)
    /// directly where an `Image` is expected.
    public enum Image {
        /// A remote or local image referenced by URL.
        case url(URL)
        /// A concrete `UIImage` used as-is.
        case image(UIImage)
    }
}

extension Aiuta.Configuration.Icon: ExpressibleByStringLiteral {
    /// Initializes an `Icon` from a string literal.
    ///
    /// Behavior:
    /// - Attempts to parse the string as a `URL`.
    /// - If parsing succeeds, stores `.url(url, renderingMode: .alwaysTemplate)`.
    /// - If parsing fails, falls back to `about:blank` to avoid a crash while keeping a valid value.
    ///
    /// Notes:
    /// - Default rendering mode is `.alwaysTemplate`, suitable for monochrome template icons
    ///   that adopt `tintColor`.
    /// - Adjust the fallback strategy to fit your app’s error handling and logging policies.
    public init(stringLiteral value: String) {
        if let url = URL(string: value) {
            self = .url(url, renderingMode: .alwaysTemplate)
        } else {
            // Fallback to an empty data URL to avoid crashing; adjust as needed for your app
            self = .url(URL(string: "about:blank")!, renderingMode: .alwaysTemplate)
        }
    }
}

extension Aiuta.Configuration.Image: ExpressibleByStringLiteral {
    /// Initializes an `Image` from a string literal.
    ///
    /// Behavior:
    /// - Attempts to parse the string as a `URL`.
    /// - If parsing succeeds, stores `.url(url)`.
    /// - If parsing fails, falls back to `about:blank` to avoid a crash while keeping a valid value.
    ///
    /// Notes:
    /// - Consider replacing the `about:blank` fallback with your own placeholder URL or
    ///   a validation error path depending on your app’s needs.
    public init(stringLiteral value: String) {
        if let url = URL(string: value) {
            self = .url(url)
        } else {
            self = .url(URL(string: "about:blank")!)
        }
    }
}
