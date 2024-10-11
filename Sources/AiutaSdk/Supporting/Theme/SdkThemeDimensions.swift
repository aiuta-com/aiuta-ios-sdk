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

@_spi(Aiuta) import AiutaKit
import UIKit

struct SdkThemeDimensions: DesignSystemDimensions {}

extension DesignSystemDimensions {
    var imageMainRadius: CGFloat { appearance.imageMainRadius ?? 24 }
    var imageBoardingRadius: CGFloat { appearance.imageBoardingRadius ?? 16 }
    var imagePreviewRadius: CGFloat { appearance.imagePreviewRadius ?? 16 }

    var bottomSheetRadius: CGFloat { appearance.bottomSheetRadius ?? 16 }

    var buttonLargeRadius: CGFloat { appearance.buttonLargeRadius ?? 8 }
    var buttonSmallRadius: CGFloat { appearance.buttonSmallRadius ?? 8 }
}

extension DesignSystemDimensions {
    var grabberWidth: CGFloat { appearance.grabberWidth ?? 36 }
    var grabberOffset: CGFloat { appearance.grabberOffset ?? 6 }
}

extension DesignSystemDimensions {
    var continuingSeparators: Bool { appearance.continuingSeparators ?? false }
}