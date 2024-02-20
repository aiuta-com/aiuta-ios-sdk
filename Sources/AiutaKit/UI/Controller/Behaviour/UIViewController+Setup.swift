//
//  Created by nGrey on 05.07.2023.
//

import UIKit

extension UIViewController {
    // at the end of init()
    @objc open func prepare() {}

    // on viewDidLoad()
    @objc open func setup() {}

    // on viewDidLoad()
    @objc open func start() async {}

    // on first viewWillAppear()
    @objc open func whenWillAppear() {}

    // on first viewDidAppear() only
    @objc open func whenAttached() {}

    // when dismissed
    @objc open func whenDettached() {}

    // on viewDidAppear()
    // further calls possible, but only if has viewDidDisappear()
    // so it will be called only once between real appears
    @objc open func whenDidAppear() {}

    // on viewDidDisappear()
    @objc open func whenDidDisappear() {}

    // before dismiss indicating
    @objc open func whenDismiss(interactive: Bool) {}

    // when interctive dismiss canceled
    @objc open func whenCancelDismiss() {}

    // will be dissmised by presenting other
    @objc open func whenPushback() {}

    // when will be presented back when returning by backstack
    @objc open func whenPopback() {}
}
