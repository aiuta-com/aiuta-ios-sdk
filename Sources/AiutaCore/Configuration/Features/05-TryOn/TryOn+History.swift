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
    /// Configures the generations history functionality for the TryOn feature.
    /// You can use the default settings, disable the history, or customize the
    /// behavior and text content for the generations history.
    public enum GenerationsHistory {
        /// Use the default configuration for generations history.
        case `default`

        /// Disable the generations history functionality.
        case none

        /// Use a custom configuration for generations history.
        ///
        /// - Parameters:
        ///   - icons: Custom icons for the generations history.
        ///   - strings: Custom text content for the generations history.
        ///   - history: An implementation for managing the generations
        ///              history data.
        case custom(icons: Icons,
                    strings: Strings,
                    history: HistoryProvider)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Defines the text content used in the generations history functionality.
    /// You can use the default text, provide custom strings, or implement a
    /// custom provider to manage the text content.
    public enum Strings {
        /// Use the default text content for generations history.
        case `default`

        /// Specify custom text content for generations history.
        ///
        /// - Parameters:
        ///   - generationsHistoryPageTitle: The title displayed on the
        ///     generations history page.
        case custom(generationsHistoryPageTitle: String)

        /// Use a custom implementation to manage the text content for
        /// generations history.
        ///
        /// - Parameters:
        ///   - provider: An object that conforms to the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory.Strings {
    /// A protocol for managing the text content of generations history. You can
    /// implement this protocol to define the title displayed on the generations
    /// history page.
    public protocol Provider {
        /// The title displayed on the generations history page.
        var generationsHistoryPageTitle: String { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Defines the icons used for the generations history functionality.
    /// You can use the default icons, provide custom ones, or implement a custom
    /// provider to manage the icons.
    public enum Icons {
        /// Use the default icons for the generations history functionality.
        case builtIn

        /// Specify custom icons for the generations history functionality.
        ///
        /// - Parameters:
        ///   - history24: The icon for the History button of the page bar.
        case custom(history24: UIImage)

        /// Use a custom implementation to manage the icons for the generations
        /// history functionality.
        ///
        /// - Parameters:
        ///   - provider: An object that conforms to the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory.Icons {
    /// A protocol for managing the icons used in the generations history
    /// functionality.
    public protocol Provider {
        /// The icon for the History button of the page bar.
        var history24: UIImage { get }
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Configures how the generations history data is managed. You can use
    /// built-in storage or provide a custom implementation for managing the
    /// history.
    public enum HistoryProvider {
        /// Use built-in `UserDefaults` to store the generations history.
        case userDefaults

        /// Use a custom implementation for managing the generations history.
        ///
        /// - Parameters:
        ///   - provider: A custom implementation that handles the generations
        ///     history data and operations.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// A protocol for managing the generations history data. You can implement
    /// this protocol to define how images are added, retrieved, and removed
    /// from the history.
    public protocol DataProvider {
        /// The observable list of generated images in the history.
        @available(iOS 13.0.0, *)
        var generated: Aiuta.Observable<[Aiuta.GeneratedImage]> { get async }

        /// Adds new images to the generations history. You should store the
        /// images and may associate them with the corresponding product IDs.
        ///
        /// - Parameters:
        ///   - images: The array of images to add to the history.
        @available(iOS 13.0.0, *)
        func add(generated images: [Aiuta.GeneratedImage]) async throws

        /// Removes images from the generations history.
        ///
        /// - Parameters:
        ///   - images: The array of images to remove from the history.
        @available(iOS 13.0.0, *)
        func delete(generated images: [Aiuta.GeneratedImage]) async throws
    }
}
