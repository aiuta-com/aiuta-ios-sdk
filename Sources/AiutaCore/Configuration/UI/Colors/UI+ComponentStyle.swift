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
    /// Adjusting colors on some buttons and status views, where explicitly available.
    ///
    /// This enum defines styles for components that can adapt to different
    /// backgrounds or themes. The styles are designed to ensure that the
    /// components remain visually appealing and accessible across various
    /// backgrounds, such as light and dark modes.
    public enum ComponentStyle {
        /// `brand` background color
        /// `onDark` foreground color for labels and icons
        case brand
        
        //// - Parameters:
        ///    `style` - The contrast style to apply to the component.
        case contrast(_ style: ContrastStyle = .lightOnDark)
        
        /// Apply a blurred background that matches the color scheme (`light` or `dark`)
        /// `primary` foreground color for labels and icons
        ///
        /// - Parameters:
        ///   - hasOutline: Indicates whether the component has `outline` color border.
        case blurred(hasOutline: Bool = false)
    }
    
    /// Contrast styles for components that adapt to different backgrounds.
    public enum ContrastStyle {
        
        /// `onLight` background color
        /// `onDark` foreground color for labels and icons
        case lightOnDark
        
        /// `onDark` background color
        /// `onLight` foreground color for labels and icons
        case darkOnLight
    }
}
