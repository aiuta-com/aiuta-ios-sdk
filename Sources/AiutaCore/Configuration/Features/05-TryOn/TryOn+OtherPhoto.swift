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
    /// "Continue with Other Photo" functionality configuration.
    public struct ContinueWithOtherPhoto: Sendable {
        /// Icons for the "Continue with Other Photo" action.
        public let icon: Icons
        
        /// Creates a "Continue with Other Photo" configuration.
        ///
        /// - Parameters:
        ///   - icon: Icons for the "Continue with Other Photo" action.
        public init(icon: Icons) {
            self.icon = icon
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.ContinueWithOtherPhoto {
    /// Icons for the "Continue with Other Photo" functionality.
    public struct Icons: Sendable {
        /// Icon for the "Change Photo" action.
        public let changePhoto24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - changePhoto24: Icon for the "Change Photo" action.
        public init(changePhoto24: UIImage) {
            self.changePhoto24 = changePhoto24
        }
    }
}
