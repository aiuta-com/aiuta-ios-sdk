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

extension Aiuta.Configuration.Features.ImagePicker {
    /// Represents the predefined models feature within the image picker. This
    /// allows you to configure how predefined models are handled, whether they
    /// use default settings, are disabled, or are customized with specific
    /// icons and strings.
    public enum PredefinedModels {
        /// Use the default configuration for predefined models.
        case `default`

        /// Disable the predefined models feature entirely.
        case none

        /// Define a custom configuration for predefined models.
        ///
        /// - Parameters:
        ///   - data: The data source for predefined models, which can be either
        ///   - icons: Custom icons to be used for the predefined models interface.
        ///   - strings: Custom text content for the predefined models interface.
        case custom(data: Data = .default,
                    icons: Icons = .builtIn,
                    strings: Strings = .default)
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Represents the data source for predefined models in the image picker.
    public enum Data {
        /// Use the default predefined models data provided by the SDK.
        case `default`

        /// Use a custom provider to supply predefined models data.
        /// - Parameters:
        ///  - preferredCategoryId: Identifier of the preferred category to show by default when user opens models page.
        case custom(preferredCategoryId: String)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Represents the icons used in the predefined models feature of the image
    /// picker. You can use default icons, provide custom ones, or supply them
    /// dynamically through a provider.
    public enum Icons {
        /// Use the default set of icons provided by the SDK.
        case builtIn

        /// Define custom icons for the predefined models interface.
        ///
        /// - Parameters:
        ///   - selectModels24: The icon displayed for the predefined models
        ///     button in the bottom sheet list.
        case custom(selectModels24: UIImage)

        /// Use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels.Icons {
    /// A protocol for supplying custom icons to the predefined models feature.
    /// Implement this protocol to provide a custom set of icons dynamically.
    public protocol Provider {
        /// The icon displayed for the predefined models button in the bottom
        /// sheet list.
        var selectModels24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Represents the text content used in the predefined models feature of the
    /// image picker. You can use default text, provide custom strings, or supply
    /// them dynamically through a provider.
    public enum Strings {
        /// Use the default text content provided by the SDK.
        case `default`

        /// Define custom text content for the predefined models interface.
        ///
        /// - Parameters:
        ///   - predefinedModelsTitle: The title of the predefined models page
        ///     and button in the bottom sheet list.
        ///   - predefinedModelsOr: The label displayed before the predefined
        ///     models button in the image picker.
        ///   - predefinedModelsEmptyListError: The error message shown when the
        ///     list of predefined models is empty.
        ///   - predefinedModelsCategories: A mapping of `categoryId` to
        ///     `categoryTitle` for predefined models categories.
        ///      The `predefinedModelCategories` are usually should cover 2 categories
        ///      with ids `man` and `woman`, but can be extended in the future or by
        ///      your agreement with Aiuta.
        case custom(predefinedModelsTitle: String,
                    predefinedModelsOr: String,
                    predefinedModelsEmptyListError: String,
                    predefinedModelsCategories: [String: String])

        /// Use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels.Strings {
    /// A protocol for supplying custom text content to the predefined models
    /// feature. Implement this protocol to provide titles, labels, error
    /// messages, and category mappings.
    public protocol Provider {
        /// The title of the predefined models page and button in the bottom
        /// sheet list.
        var predefinedModelsTitle: String { get }

        /// The label displayed before the predefined models button in the
        /// image picker.
        var predefinedModelsOr: String { get }

        /// The error message shown when the list of predefined models is empty.
        var predefinedModelsEmptyListError: String { get }

        /// A mapping of `categoryId` to `categoryTitle` for predefined models
        /// categories.
        ///
        /// The `predefinedModelCategories` are usually should cover 2 categories with
        /// ids `man` and `woman`, but can be extended in the future or by your
        /// agreement with Aiuta.
        var predefinedModelsCategories: [String: String] { get }
    }
}
