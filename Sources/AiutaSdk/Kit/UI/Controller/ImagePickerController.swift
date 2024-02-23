//
// Created by nGrey on 24.02.2023.
//

import Foundation
import Resolver
import UIKit

class ImagePickerController<ViewContent>: UIImagePickerController where ViewContent: ContentBase {
    @Injected private(set) var ds: DesignSystem
    var ui: ViewContent { _ui }
    private var _ui: ViewContent!

    override func loadView() {
        prepare()
        modalPresentationStyle = .popover
        super.loadView()
        _ui = ViewContent()
        ui.isRoot = true
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
}
