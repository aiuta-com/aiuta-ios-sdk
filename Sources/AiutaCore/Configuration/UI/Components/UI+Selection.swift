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
    /// Selection snackbar theme configuration.
    public struct SelectionSnackbarTheme: Sendable {
        /// Text strings used in the snackbar.
        public let strings: Strings
        
        /// Icons displayed in the snackbar.
        public let icons: Icons
        
        /// Color scheme for the snackbar.
        public let colors: Colors
        
        /// Creates a custom selection snackbar theme.
        ///
        /// - Parameters:
        ///   - strings: Text strings used in the snackbar.
        ///   - icons: Icons displayed in the snackbar.
        ///   - colors: Color scheme for the snackbar.
        public init(strings: Strings,
                    icons: Icons,
                    colors: Colors) {
            self.strings = strings
            self.icons = icons
            self.colors = colors
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Text strings configuration for the selection snackbar.
    public struct Strings: Sendable {
        /// The text for the "select" action.
        public let select: String
        
        /// The text for the "cancel" action.
        public let cancel: String
        
        /// The text for the "select all" action.
        public let selectAll: String
        
        /// The text for the "unselect all" action.
        public let unselectAll: String
        
        /// Creates custom strings configuration.
        ///
        /// - Parameters:
        ///   - select: The text for the "select" action.
        ///   - cancel: The text for the "cancel" action.
        ///   - selectAll: The text for the "select all" action.
        ///   - unselectAll: The text for the "unselect all" action.
        public init(select: String,
                    cancel: String,
                    selectAll: String,
                    unselectAll: String) {
            self.select = select
            self.cancel = cancel
            self.selectAll = selectAll
            self.unselectAll = unselectAll
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Icon configuration for the selection snackbar.
    public struct Icons: Sendable {
        /// The icon for the delete action.
        public let trash24: UIImage
        
        /// The icon for the selected item state.
        public let check20: UIImage
        
        /// Creates custom icon configuration.
        ///
        /// - Parameters:
        ///   - trash24: The icon for the delete action.
        ///   - check20: The icon for the selected item state.
        public init(trash24: UIImage,
                    check20: UIImage) {
            self.trash24 = trash24
            self.check20 = check20
        }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Color scheme for the selection snackbar.
    public struct Colors: Sendable {
        /// The background color for the snackbar.
        public let selectionBackground: UIColor
        
        /// Creates custom color configuration.
        ///
        /// - Parameters:
        ///   - selectionBackground: The background color for the snackbar.
        public init(selectionBackground: UIColor) {
            self.selectionBackground = selectionBackground
        }
    }
}
