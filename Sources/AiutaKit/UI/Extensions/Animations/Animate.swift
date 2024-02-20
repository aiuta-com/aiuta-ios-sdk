//
// Created by nGrey on 02.02.2023.
//

import UIKit

public extension UIResponder {

    //TODO Deprecate
    func animate(time duration: AsyncDelayTime = .sixthOfSecond, changes: @escaping AsyncCallback) {
        UIView.animate(withDuration: duration.seconds, animations: changes)
    }
}
