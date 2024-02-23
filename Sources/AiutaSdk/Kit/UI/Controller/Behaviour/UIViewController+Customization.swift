//
//  Created by nGrey on 05.07.2023.
//


import UIKit

extension UIViewController {
    func customizeLoading() {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
        navigationItem.hidesBackButton = true
        hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .pull(direction: .right))
        hero.isEnabled = true
    }

    func customizeAppearing() {
        isDeparting = false
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
