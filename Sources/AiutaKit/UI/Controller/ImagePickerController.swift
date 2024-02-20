//
// Created by nGrey on 24.02.2023.
//

import Foundation
import Resolver
import Toast
import UIKit

open class ImagePickerController<ViewContent>: UIImagePickerController where ViewContent: ContentBase {
    @Injected public private(set) var ds: DesignSystem
    public var ui: ViewContent { _ui }
    private var _ui: ViewContent!

    override public func loadView() {
        prepare()
        modalPresentationStyle = .popover
        super.loadView()
        _ui = ViewContent()
        ui.isRoot = true
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
}
