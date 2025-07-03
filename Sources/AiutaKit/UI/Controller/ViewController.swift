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

@_spi(Aiuta) open class ViewController<ViewContent>: UIViewController where ViewContent: ContentBase {
    @Injected
    public private(set) var ds: DesignSystem
    public var ui: ViewContent { _ui }
    private var _ui: ViewContent!

    @notification(UIResponder.keyboardWillShowNotification)
    private var keyboardWillShow: Signal<Void>

    @notification(UIResponder.keyboardWillHideNotification)
    private var keyboardWillHide: Signal<Void>

    @notification(UIResponder.keyboardWillChangeFrameNotification)
    private var keyboardWillChangeFrame: Signal<Void>

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        customizeLoading()
        prepare()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }

    override public func loadView() {
        _ui = ViewContent()
        ui.isRoot = true
        view = ui.container
        view.backgroundColor = ds.kit.ground
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = ds.kit.style
        }
        ui.addChildren(to: view)
        assert(view is ContentView, "ViewController base view content must be ContentView")
    }

    override open func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        if let childView = childController.view as? ContentView,
           let childContent = childView.content {
            ui.addContent(childContent)
        } else {
            view.addSubview(childController.view)
        }
    }

    override open func viewDidLoad() {
        setup()
        if #available(iOS 13.0, *) {
            Task { await start() }
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeAppearing()
        if !isAppearing {
            whenWillAppear()
        }
        watchKeyboard()
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

    private func watchKeyboard() {
        guard keyboardWillShow.observers.isEmpty else { return }

        let keyboardHandler = { [unowned self] in
            guard isAppearing, isViewLoaded else { return }
            ui.updateLayoutRecursive()
        }

        keyboardWillShow.subscribe(with: self, callback: keyboardHandler)
        keyboardWillHide.subscribe(with: self, callback: keyboardHandler)
        keyboardWillChangeFrame.subscribe(with: self, callback: keyboardHandler)
    }
}
