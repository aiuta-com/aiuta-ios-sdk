//
// Created by nGrey on 24.02.2023.
//

import Foundation
import Resolver
import UIKit

class TabBarController<ViewContent>: UITabBarController where ViewContent: ContentBase {
    @Injected
    private(set) var ds: DesignSystem
    var ui: ViewContent { _ui }
    private var _ui: ViewContent!

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        customizeLoading()
        prepare()
    }

    override func loadView() {
        _ui = ViewContent()
        super.loadView()
        tabBar.isHidden = true
        ui.isRoot = true
        view.backgroundColor = ds.color.ground
        ui.container.backgroundColor = ds.color.ground
        view.addSubview(ui.container)
        ui.addChildren(to: ui.container)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeAppearing()
        if !isAppearing {
            whenWillAppear()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customizeAppearing()
        isAttached = true
        isAppearing = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isAppearing = false
    }
    
    override func viewWillLayoutSubviews() {
        ui.updateLayoutRecursive()
    }
}
