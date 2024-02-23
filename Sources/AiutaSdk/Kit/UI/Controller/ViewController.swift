//
// Created by nGrey on 23.02.2023.
//

import Foundation
import Resolver
import UIKit

class ViewController<ViewContent>: UIViewController where ViewContent: ContentBase {
    @Injected
    private(set) var ds: DesignSystem
    var ui: ViewContent { _ui }
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    override func loadView() {
        _ui = ViewContent()
        ui.isRoot = true
        view = ui.container
        view.backgroundColor = ds.color.ground
        ui.addChildren(to: view)
        assert(view is ContentView, "ViewController base view content must be ContentView")
    }

    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        if let childView = childController.view as? ContentView,
           let childContent = childView.content {
            ui.addContent(childContent)
        } else {
            view.addSubview(childController.view)
        }
    }

    override func viewDidLoad() {
        setup()
        if #available(iOS 13.0, *) {
            Task { await start() }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeAppearing()
        if !isAppearing {
            whenWillAppear()
        }
        watchKeyboard()
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
