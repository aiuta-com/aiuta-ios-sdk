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

@_spi(Aiuta) extension UIViewController {
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
