//
// Created by nGrey on 04.02.2023.
//

import UIKit

protocol DesignSystem {
    var style: DesignSystemStyles { get }
    var image: DesignSystemImages { get }
    var color: DesignSystemColors { get }
    var font: DesignSystemFonts { get }
    var dimensions: DesignSystemDimensions { get }
    var transition: DesignSystemTransitions { get }
}

protocol DesignSystemColors {
    var ground: UIColor { get }
    var popup: UIColor { get }
    var item: UIColor { get }
    var accent: UIColor { get }
    var tint: UIColor { get }
    var highlight: UIColor { get }
    var error: UIColor { get }

    //TODO color pairs
}

protocol DesignSystemFonts {
    var `default`: FontRef { get }
}

protocol DesignSystemDimensions {}

protocol DesignSystemStyles {}

protocol DesignSystemImages {}

protocol DesignSystemTransitions {}
