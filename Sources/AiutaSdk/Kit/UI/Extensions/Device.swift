//
// Created by nGrey on 03.02.2023.
//

import UIKit

extension UIDevice {
    func rotate(to orientation: UIDeviceOrientation) {
        setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
