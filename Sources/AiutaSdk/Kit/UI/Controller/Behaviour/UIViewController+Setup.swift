//
//  Created by nGrey on 05.07.2023.
//

import UIKit

extension UIViewController {
    // at the end of init()
    @objc func prepare() {}

    // on viewDidLoad()
    @objc func setup() {}

    // on viewDidLoad()
    @available(iOS 13.0.0, *)
    @objc func start() async {}

    // on first viewWillAppear()
    @objc func whenWillAppear() {}

    // on first viewDidAppear() only
    @objc func whenAttached() {}

    // when dismissed
    @objc func whenDettached() {}

    // on viewDidAppear()
    // further calls possible, but only if has viewDidDisappear()
    // so it will be called only once between real appears
    @objc func whenDidAppear() {}

    // on viewDidDisappear()
    @objc func whenDidDisappear() {}

    // before dismiss indicating
    @objc func whenDismiss(interactive: Bool) {}

    // when interctive dismiss canceled
    @objc func whenCancelDismiss() {}

    // will be dissmised by presenting other
    @objc func whenPushback() {}

    // when will be presented back when returning by backstack
    @objc func whenPopback() {}
}
