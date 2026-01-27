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
    /// Bottom sheet theme configuration.
    public struct BottomSheetTheme: Sendable {
        /// Text style for icon buttons within the bottom sheet.
        public let typography: Typography
        
        /// Corner radius for the bottom sheet container.
        public let shapes: Shapes
        
        /// Drag indicator at the top of the bottom sheet.
        public let grabber: Grabber
        
        /// Delimiter positioning (visual boundaries within the sheet).
        public let settings: Settings
        
        /// Creates a custom bottom sheet theme.
        ///
        /// - Parameters:
        ///   - typography: Text style for icon buttons within the bottom sheet.
        ///   - shapes: Corner radius for the bottom sheet container.
        ///   - grabber: Drag indicator at the top of the bottom sheet.
        ///   - settings: Delimiter positioning (visual boundaries within the sheet).
        public init(typography: Typography,
                    shapes: Shapes,
                    grabber: Grabber,
                    settings: Settings) {
            self.typography = typography
            self.shapes = shapes
            self.grabber = grabber
            self.settings = settings
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Typography for bottom sheet text elements.
    public struct Typography: Sendable {
        /// Text style for icon buttons (buttons with both icon and text).
        public let iconButton: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography.
        ///
        /// - Parameters:
        ///   - iconButton: Text style for icon buttons (buttons with both icon and text).
        public init(iconButton: Aiuta.Configuration.TextStyle) {
            self.iconButton = iconButton
        }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Shape style for the bottom sheet container.
    public struct Shapes: Sendable {
        /// Corner radius and shape applied to the bottom sheet container.
        public let bottomSheet: Aiuta.Configuration.Shape
        
        /// Creates custom shape.
        ///
        /// - Parameters:
        ///   - bottomSheet: Corner radius and shape applied to the bottom sheet container.
        public init(bottomSheet: Aiuta.Configuration.Shape) {
            self.bottomSheet = bottomSheet
        }
    }
}

// MARK: - Grabber

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Drag indicator (grabber) at the top of the bottom sheet.
    ///
    /// Visual indicator that allows users to drag the sheet up/down.
    /// Set height to 0 to disable.
    public struct Grabber: Sendable {
        /// Width of the grabber indicator.
        public let width: CGFloat
        
        /// Height of the grabber indicator. Set to 0 to disable.
        public let height: CGFloat
        
        /// Vertical offset from the top of the bottom sheet.
        public let offset: CGFloat
        
        /// Creates a custom grabber configuration.
        ///
        /// - Parameters:
        ///   - width: The width of the grabber.
        ///   - height: The height of the grabber. Set to 0 to disable the grabber.
        ///   - offset: The vertical offset of the grabber from the top of the bottom sheet.
        public init(width: CGFloat,
                    height: CGFloat,
                    offset: CGFloat) {
            self.width = width
            self.height = height
            self.offset = offset
        }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Delimiter options for the bottom sheet.
    ///
    /// Visual boundaries such as insets or edge extensions.
    public enum Delimieters: Sendable {
        /// Use the default inset for delimiters.
        case defaultInset

        /// Extend delimiters to the right edge of the sheet.
        case extendToTheRight

        /// Extend delimiters to both edges of the sheet.
        case extendToTheLeftAndRight
    }

    /// Behavior and layout settings for the bottom sheet.
    public struct Settings: Sendable {
        /// Whether to extend delimiters to the right edge.
        public let extendDelimitersToTheRight: Bool
        
        /// Whether to extend delimiters to the left edge.
        public let extendDelimitersToTheLeft: Bool
        
        /// Creates custom settings for the bottom sheet.
        ///
        /// - Parameters:
        ///   - extendDelimitersToTheRight: Whether to extend delimiters to the right edge.
        ///   - extendDelimitersToTheLeft: Whether to extend delimiters to the left edge.
        public init(extendDelimitersToTheRight: Bool,
                    extendDelimitersToTheLeft: Bool) {
            self.extendDelimitersToTheRight = extendDelimitersToTheRight
            self.extendDelimitersToTheLeft = extendDelimitersToTheLeft
        }
    }
}
