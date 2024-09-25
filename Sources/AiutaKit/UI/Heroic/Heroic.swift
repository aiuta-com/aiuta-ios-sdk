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

@_spi(Aiuta) public protocol Heroic {
    var isTransitioning: Bool { get }
    var willStartTransition: Signal<Void> { get }
    var didCompleteTransition: Signal<Void> { get }

    func completeTransition() async

    func setEnabled(_ value: Bool, for vc: UIViewController)
    func customize(for vc: UIViewController)

    func setId(_ value: String?, for view: UIView)
    func setModifiers(_ value: [TransitionMaker]?, for view: UIView)

    func copyAnimation(from: UIViewController, to navigationController: UINavigationController?)
    func replace(_ viewController: UIViewController, with: UIViewController)

    func update(percent: CGFloat)
    func finish(animate: Bool)
    func cancel(animate: Bool)
}
