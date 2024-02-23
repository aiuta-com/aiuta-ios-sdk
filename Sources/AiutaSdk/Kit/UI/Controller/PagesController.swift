//
//  Created by nGrey on 01.07.2023.
//

import Foundation
import Resolver
import UIKit

class PagesController<ViewContent>: UIPageViewController where ViewContent: ContentBase {
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
        self.init(transitionStyle: .scroll,
                  navigationOrientation: .horizontal,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: 4])
        customizeLoading()
        prepare()
    }

    override func loadView() {
        _ui = ViewContent()
        super.loadView()
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
        viewControllers?.forEach { sub in
            sub.viewAsUI?.updateLayoutRecursive()
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
    
    override func viewWillLayoutSubviews() {
        ui.updateLayoutRecursive()
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
