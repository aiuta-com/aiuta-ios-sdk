//
// Created by nGrey on 02.02.2023.
//

import UIKit

extension UIColor {
    convenience init(hex: Int64) {
        let red: CGFloat = CGFloat((hex & 0xFF000000) >> 24) / 255
        let green: CGFloat = CGFloat((hex & 0x00FF0000) >> 16) / 255
        let blue: CGFloat = CGFloat((hex & 0x0000FF00) >> 8) / 255
        let alpha: CGFloat = CGFloat(hex & 0x000000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init?(hexString: String?) {
        guard let hexString else { return nil }
        self.init(hexString: hexString)
    }
}

extension Int {
    var uiColor: UIColor {
        UIColor(hex: Int64(self))
    }

    var cgColor: CGColor {
        uiColor.cgColor
    }
}
