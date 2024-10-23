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

@_spi(Aiuta) public protocol DesignSystem {
    var style: DesignSystemStyles { get }
    var image: DesignSystemImages { get }
    var color: DesignSystemColors { get }
    var font: DesignSystemFonts { get }
    var dimensions: DesignSystemDimensions { get }
    var transition: DesignSystemTransitions { get }
}

@_spi(Aiuta) public protocol DesignSystemColors {
    var style: UIUserInterfaceStyle { get }
    var ground: UIColor { get }
    var popup: UIColor { get }
    var item: UIColor { get }
    var accent: UIColor { get }
    var tint: UIColor { get }
    var highlight: UIColor { get }
    var error: UIColor { get }
}

@_spi(Aiuta) public protocol DesignSystemFonts {
    var `default`: FontRef { get }
}

@_spi(Aiuta) public protocol DesignSystemDimensions {}

@_spi(Aiuta) public protocol DesignSystemStyles {}

@_spi(Aiuta) public protocol DesignSystemImages {}

@_spi(Aiuta) public protocol DesignSystemTransitions {}
