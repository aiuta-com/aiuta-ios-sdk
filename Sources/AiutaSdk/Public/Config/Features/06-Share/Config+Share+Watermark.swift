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

// MARK: - Watermark

extension Aiuta.Configuration.Features.Share {
    /// Configures the watermark for the Share feature. You can choose to disable
    /// the watermark, use a custom image, or provide a dynamic watermark through
    /// a custom provider.
    public enum Watermark {
        /// No watermark will be applied to the shared content.
        case none

        /// Use a custom watermark image for the shared content.
        ///
        /// - Parameters:
        ///   - shareWatermark: The logo image to be used as the watermark.
        case custom(shareWatermark: UIImage)

        /// Use a custom provider to supply watermark images dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom watermark images.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Share.Watermark {
    /// A protocol for supplying watermark for the shared images. Implement this
    /// protocol to provide custom watermark images for the Share feature.
    public protocol Provider {
        /// The logo image to be used as the watermark.
        var shareWatermark: UIImage { get }
    }
}
