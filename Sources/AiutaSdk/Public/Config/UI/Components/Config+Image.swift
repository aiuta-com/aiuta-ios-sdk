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

extension Aiuta.Configuration.UserInterface {
    /// Configures the image theme for the SDK.
    ///
    /// This setting allows you to use the default image theme or define a custom one
    /// to better align with your application's design and visual identity.
    public enum ImageTheme {
        /// Use the default image theme provided by the SDK.
        case `default`

        /// Define a custom image theme.
        ///
        /// - Parameters:
        ///   - shapes: Specifies the shapes to use for image views.
        ///   - icons: Specifies the icons to use for image placeholders.
        case custom(shapes: Shapes = .default,
                    icons: Icons = .builtIn)
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.ImageTheme {
    /// Configures the shapes for image views.
    ///
    /// This setting allows you to use predefined shapes or define custom ones
    /// to match your application's design style.
    public enum Shapes {
        /// Use the default continuous shapes provided by the SDK.
        case `default`

        /// Use smaller continuous shapes for image views.
        case small

        /// Define custom shapes for image views.
        ///
        /// - Parameters:
        ///   - imageL: The shape to use for large image views.
        ///   - imageM: The shape to use for medium and small image views.
        case custom(imageL: Aiuta.Configuration.Shape,
                    imageM: Aiuta.Configuration.Shape)

        /// Use a custom shapes provider.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom shapes.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ImageTheme.Shapes {
    /// A protocol for providing custom shapes for image themes.
    ///
    /// This protocol defines the required shapes for large and medium/small image views.
    /// - Note: This protocol is intended for internal use. Instead, use one of the
    ///         predefined shape options or provide a custom implementation.
    public protocol Provider {
        /// The shape to use for large image views.
        var imageL: Aiuta.Configuration.Shape { get }

        /// The shape to use for medium and small image views.
        var imageM: Aiuta.Configuration.Shape { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ImageTheme {
    /// Configures the icons for image placeholders.
    ///
    /// This setting allows you to use the default icons or define custom ones
    /// to better align with your application's visual identity.
    public enum Icons {
        /// Use the default icons built into the SDK.
        case builtIn

        /// Define custom icons for image placeholders.
        ///
        /// - Parameters:
        ///   - imageError36: The icon to display when an image cannot be loaded.
        case custom(imageError36: UIImage)

        /// Use a custom icons provider.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ImageTheme.Icons {
    /// A protocol for providing custom icons for image themes.
    ///
    /// This protocol defines the required icons for image placeholders.
    /// - Note: This protocol is intended for internal use.
    ///         Use one of `Aiuta.Configuration.Icons` typealias instead.
    public protocol Provider {
        /// The icon to display when an image cannot be loaded.
        var imageError36: UIImage { get }
    }
}
