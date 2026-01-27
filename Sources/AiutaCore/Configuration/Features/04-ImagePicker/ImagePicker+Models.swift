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
    /// Predefined models feature configuration for the image picker.
    ///
    /// To disable predefined models functionality, set this to `nil` in the `ImagePicker` configuration.
    public struct PredefinedModels: Sendable {
        /// Data source for predefined models.
        public let data: Data
        
        /// Icons for the predefined models interface.
        public let icons: Icons
        
        /// Text content for the predefined models interface.
        public let strings: Strings
        
        /// Creates a custom predefined models configuration.
        ///
        /// - Parameters:
        ///   - data: Data source for predefined models.
        ///   - icons: Icons for the predefined models interface.
        ///   - strings: Text content for the predefined models interface.
        public init(data: Data,
                    icons: Icons,
                    strings: Strings) {
            self.data = data
            self.icons = icons
            self.strings = strings
        }
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Data source for predefined models in the image picker.
    public struct Data: Sendable {
        /// Identifier of the preferred category to show by default when user opens models page.
        public let preferredCategoryId: String?
        
        /// Creates custom data configuration.
        ///
        /// - Parameters:
        ///   - preferredCategoryId: Identifier of the preferred category to show by default when user opens models page.
        public init(preferredCategoryId: String?) {
            self.preferredCategoryId = preferredCategoryId
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Icons for the predefined models interface.
    public struct Icons: Sendable {
        /// Icon displayed for the predefined models button in the bottom sheet list (24x24).
        public let selectModels24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - selectModels24: Icon displayed for the predefined models button in the bottom sheet list (24x24).
        public init(selectModels24: UIImage) {
            self.selectModels24 = selectModels24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    /// Text content for the predefined models interface.
    public struct Strings: Sendable {
        /// Title of the predefined models page and button in the bottom sheet list.
        public let predefinedModelsTitle: String
        
        /// Label displayed before the predefined models button in the image picker.
        public let predefinedModelsOr: String
        
        /// Error message shown when the list of predefined models is empty.
        public let predefinedModelsEmptyListError: String
        
        /// Mapping of `categoryId` to `categoryTitle` for predefined models categories.
        ///
        /// The categories usually cover 2 IDs: `man` and `woman`, but can be extended
        /// in the future or by your agreement with Aiuta.
        public let predefinedModelsCategories: [String: String]
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - predefinedModelsTitle: Title of the predefined models page and button in the bottom sheet list.
        ///   - predefinedModelsOr: Label displayed before the predefined models button in the image picker.
        ///   - predefinedModelsEmptyListError: Error message shown when the list of predefined models is empty.
        ///   - predefinedModelsCategories: Mapping of `categoryId` to `categoryTitle` for predefined models categories.
        public init(predefinedModelsTitle: String,
                    predefinedModelsOr: String,
                    predefinedModelsEmptyListError: String,
                    predefinedModelsCategories: [String: String]) {
            self.predefinedModelsTitle = predefinedModelsTitle
            self.predefinedModelsOr = predefinedModelsOr
            self.predefinedModelsEmptyListError = predefinedModelsEmptyListError
            self.predefinedModelsCategories = predefinedModelsCategories
        }
    }
}
