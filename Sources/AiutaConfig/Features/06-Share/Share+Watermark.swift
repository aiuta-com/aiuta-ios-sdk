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

import AiutaCore
import UIKit

// MARK: - Watermark

extension Aiuta.Configuration.Features.Share {
    /// Configures the watermark for the Share feature.
    /// Set to `nil` on the parent `Share` to disable watermarking.
    public struct Watermark: Sendable {
        /// Images for the watermark feature.
        public let images: Images

        /// Creates a watermark configuration.
        ///
        /// - Parameters:
        ///   - images: Images for the watermark feature.
        public init(images: Images) {
            self.images = images
        }
    }
}

// MARK: - Watermark Images

extension Aiuta.Configuration.Features.Share.Watermark {
    /// Images for the watermark feature.
    public struct Images: Sendable {
        /// The logo image to be used as the watermark.
        public let watermark: UIImage

        /// Creates watermark images.
        ///
        /// - Parameters:
        ///   - watermark: The logo image to be used as the watermark.
        public init(watermark: UIImage) {
            self.watermark = watermark
        }
    }
}
