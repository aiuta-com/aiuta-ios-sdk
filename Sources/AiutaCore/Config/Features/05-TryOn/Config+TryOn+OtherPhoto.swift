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

extension Aiuta.Configuration.Features.TryOn {
    /// Configures the "Continue with Other Photo" functionality for the TryOn
    /// feature. You can use the default settings or customize the icons used
    /// for this functionality.
    public enum ContinueWithOtherPhoto {
        /// Use the default configuration for the "Continue with Other Photo"
        /// functionality.
        case `default`

        /// Use a custom configuration for the "Continue with Other Photo"
        /// functionality.
        ///
        /// - Parameters:
        ///   - icon: Custom icons for the "Continue with Other Photo" action.
        case custom(icon: Icons)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.ContinueWithOtherPhoto {
    /// Defines the icons used for the "Continue with Other Photo" functionality.
    /// You can use the default icons, provide custom ones, or implement a custom
    /// provider to manage the icons.
    public enum Icons {
        /// Use the default icons for the "Continue with Other Photo" functionality.
        case builtIn

        /// Specify custom icons for the "Continue with Other Photo" functionality.
        ///
        /// - Parameters:
        ///   - changePhoto24: The icon for the "Change Photo" action.
        case custom(changePhoto24: UIImage)

        /// Use a custom implementation to manage the icons for the "Continue
        /// with Other Photo" functionality.
        ///
        /// - Parameters:
        ///   - provider: An object that conforms to the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.ContinueWithOtherPhoto.Icons {
    /// A protocol for managing the icons used in the "Continue with Other Photo"
    /// functionality. You can implement this protocol to define the icon for
    /// the "Change Photo" action.
    public protocol Provider {
        /// The icon for the "Change Photo" action.
        var changePhoto24: UIImage { get }
    }
}
