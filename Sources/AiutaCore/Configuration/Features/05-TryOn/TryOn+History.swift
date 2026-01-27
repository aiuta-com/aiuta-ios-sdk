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
    /// Generations history configuration for the TryOn feature.
    public struct GenerationsHistory: Sendable {
        /// Icons for the generations history.
        public let icons: Icons
        
        /// Text content for the generations history.
        public let strings: Strings
        
        /// Implementation for managing the generations history data.
        public let history: HistoryProvider
        
        /// Creates a generations history configuration.
        ///
        /// - Parameters:
        ///   - icons: Icons for the generations history.
        ///   - strings: Text content for the generations history.
        ///   - history: Implementation for managing the generations history data.
        public init(icons: Icons,
                    strings: Strings,
                    history: HistoryProvider) {
            self.icons = icons
            self.strings = strings
            self.history = history
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Text content for generations history.
    public struct Strings: Sendable {
        /// Title displayed on the generations history page.
        public let generationsHistoryPageTitle: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - generationsHistoryPageTitle: Title displayed on the generations history page.
        public init(generationsHistoryPageTitle: String) {
            self.generationsHistoryPageTitle = generationsHistoryPageTitle
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Icons for the generations history functionality.
    public struct Icons: Sendable {
        /// Icon for the History button of the page bar.
        public let history24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - history24: Icon for the History button of the page bar.
        public init(history24: UIImage) {
            self.history24 = history24
        }
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// How the generations history data is managed.
    public enum HistoryProvider: Sendable {
        /// Use built-in `UserDefaults` to store the generations history.
        case userDefaults

        /// Use a custom implementation for managing the generations history.
        ///
        /// - Parameters:
        ///   - provider: Custom implementation that handles the generations history data.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    /// Protocol for managing the generations history data.
    public protocol DataProvider: Sendable {
        /// Observable list of generated images in the history.
        @available(iOS 13.0.0, *)
        var generated: Aiuta.Observable<[Aiuta.GeneratedImage]> { get async }

        /// Adds new images to the generations history.
        ///
        /// - Parameters:
        ///   - images: Array of images to add to the history.
        @available(iOS 13.0.0, *)
        func add(generated images: [Aiuta.GeneratedImage]) async throws

        /// Removes images from the generations history.
        ///
        /// - Parameters:
        ///   - images: Array of images to remove from the history.
        @available(iOS 13.0.0, *)
        func delete(generated images: [Aiuta.GeneratedImage]) async throws
    }
}
