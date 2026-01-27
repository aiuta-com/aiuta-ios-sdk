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

extension Aiuta.Configuration {
    /// Represents shape options for configuring the corner style of UI elements in the Aiuta SDK.
    ///
    /// Use these values to describe how views such as buttons, containers, or badges should be
    /// rounded or left square. Shapes do not perform rendering by themselves; they simply express
    /// intent that can be applied by view builders or theming layers.
    public enum Shape: Sendable {
        /// A continuous rounded shape.
        ///
        /// - Parameter radius: Corner radius in points. Larger values produce more rounded corners.
        ///   Continuous corners provide a smooth, geometry-aware curve that often looks more natural
        ///   than simple circular arcs.
        ///
        /// Typical usage: cards, large buttons, containers.
        case continuous(radius: CGFloat)

        /// A circular (uniform) rounded shape.
        ///
        /// - Parameter radius: Corner radius in points, applied uniformly using circular arcs.
        ///   This matches the classic iOS rounded-rect look.
        ///
        /// Typical usage: small buttons, tags, chips, or when you want a crisp circular rounding.
        case circular(radius: CGFloat)

        /// A rectangular shape with sharp corners (no rounding).
        ///
        /// Typical usage: utility bars, tables, or when the design calls for strict geometry.
        case rectangular
    }
}

/// Allows using a floating-point literal to specify a continuous corner radius.
///
/// Example:
/// ```swift
/// let shape: Aiuta.Configuration.Shape = 12.5
/// // Equivalent to: .continuous(radius: 12.5)
/// ```
extension Aiuta.Configuration.Shape: ExpressibleByFloatLiteral {
    /// Initializes a `.continuous` shape using the literal value as the radius (in points).
    public init(floatLiteral value: Double) {
        self = .continuous(radius: CGFloat(value))
    }
}

/// Allows using an integer literal to specify a continuous corner radius.
///
/// Example:
/// ```swift
/// let shape: Aiuta.Configuration.Shape = 8
/// // Equivalent to: .continuous(radius: 8)
/// ```
extension Aiuta.Configuration.Shape: ExpressibleByIntegerLiteral {
    /// Initializes a `.continuous` shape using the literal value as the radius (in points).
    public init(integerLiteral value: Int) {
        self = .continuous(radius: CGFloat(value))
    }
}
