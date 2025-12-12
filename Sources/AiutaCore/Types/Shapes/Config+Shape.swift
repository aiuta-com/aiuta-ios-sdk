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
    /// Represents the shape configuration options available in the Aiuta SDK.
    /// These shapes are used to define the appearance of UI components, such
    /// as buttons or containers, by specifying their corner styles.
    public enum Shape {
        /// A continuous shape with rounded corners. You can specify the corner
        /// radius to control how rounded the corners appear.
        ///
        /// - Parameters:
        ///   - radius: The corner radius to apply to the shape. A higher value
        ///     results in more rounded corners.
        case continuous(radius: CGFloat)

        /// A circular shape with a uniform corner radius. This is useful for
        /// creating elements like circular buttons or icons.
        ///
        /// - Parameters:
        ///   - radius: The corner radius to apply to the shape. This value
        ///     determines the curvature of the circular edges.
        case circular(radius: CGFloat)

        /// A rectangular shape with sharp corners for elements that do not
        /// require rounded edges.
        case rectangular
    }
}
