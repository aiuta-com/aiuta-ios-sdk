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

import Foundation
import Resolver
import UIKit

@_spi(Aiuta) open class TabBarController<ViewContent>: UITabBarController where ViewContent: ContentBase {
    @Injected
    public private(set) var ds: DesignSystem
    public var ui: ViewContent { _ui }
    private var _ui: ViewContent!

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        customizeLoading()
        prepare()
    }

    override public func loadView() {
        _ui = ViewContent()
        super.loadView()
        tabBar.isHidden = true
        ui.isRoot = true
        view.backgroundColor = ds.color.ground
        ui.container.backgroundColor = ds.color.ground
        view.addSubview(ui.container)
        ui.addChildren(to: ui.container)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeAppearing()
        if !isAppearing {
            whenWillAppear()
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeAppearing()
        isAttached = true
        isAppearing = true
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppearing = false
    }
    
    open override func viewWillLayoutSubviews() {
        ui.updateLayoutRecursive()
    }
}
