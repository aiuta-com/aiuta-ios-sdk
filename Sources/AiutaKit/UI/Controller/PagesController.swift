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

@_spi(Aiuta) open class PagesController<ViewContent>: UIPageViewController, UIPageViewControllerDelegate, UIScrollViewDelegate where ViewContent: ContentBase {
    @Injected public private(set) var ds: DesignSystem
    public var ui: ViewContent { _ui }
    private var _ui: ViewContent!
    public private(set) var scroll: UIScrollView?

    @notification(UIResponder.keyboardWillShowNotification)
    private var keyboardWillShow: Signal<Void>

    @notification(UIResponder.keyboardWillHideNotification)
    private var keyboardWillHide: Signal<Void>

    @notification(UIResponder.keyboardWillChangeFrameNotification)
    private var keyboardWillChangeFrame: Signal<Void>

    public convenience init() {
        self.init(interPageSpacing: 0)
    }

    public convenience init(interPageSpacing: CGFloat) {
        self.init(transitionStyle: .scroll,
                  navigationOrientation: .horizontal,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: interPageSpacing])
        customizeLoading()
        prepare()
    }

    override public func loadView() {
        _ui = ViewContent()
        super.loadView()
        ui.isRoot = true
        view.backgroundColor = ds.color.ground
        ui.container.backgroundColor = nil
        view.addSubview(ui.container)
        ui.addChildren(to: ui.container)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        scroll = view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        setup()
        delegate = self
        scroll?.delegate = self
    }

    override open func viewWillAppear(_ animated: Bool) {
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

    override open func viewWillLayoutSubviews() {
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

    // MARK: - UIPageViewControllerDelegate

    public struct TransitionInfo {
        public let currentViewController: UIViewController?
        public let pendingViewController: UIViewController?
        public let transitionProgress: CGFloat
        public let direction: UIPageViewController.NavigationDirection
        public let isDrag: Bool

        public func willMatchDirectionTransition(fromIndex: Int, toIndex: Int) -> Bool {
            switch direction {
                case .forward: return toIndex > fromIndex
                case .reverse: return toIndex < fromIndex
                @unknown default: return false
            }
        }
    }

    public let didChangeCurrentViewController = Signal<UIViewController?>()
    public let willTransitionTo = Signal<UIViewController?>()
    public let didTransition = Signal<TransitionInfo>()

    public private(set) weak var currentViewController: UIViewController? {
        didSet {
            guard currentViewController !== oldValue else { return }
            didChangeCurrentViewController.fire(currentViewController)
        }
    }

    public private(set) weak var pendingViewController: UIViewController? {
        didSet { willTransitionTo.fire(pendingViewController) }
    }

    private var willRefreshDataSource = false

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewController = pendingViewControllers.first
        pendingViewController?.view.backgroundColor = .clear
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        resetCurrentViewController(refreshDataSource: true)
    }

    public func setViewController(_ viewController: UIViewController?, direction: UIPageViewController.NavigationDirection = .forward,
                                  animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        setViewControllers([viewController].compactMap { $0 }, direction: direction, animated: animated, completion: completion)
    }

    override public func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewController.NavigationDirection,
                                            animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if animated {
            scroll?.isUserInteractionEnabled = false
            delay(.thirdOfSecond) { [weak self] in
                self?.scroll?.isUserInteractionEnabled = true
                self?.resetCurrentViewController()
            }
        }
        pendingViewController = viewControllers?.first
        viewControllers?.forEach { $0.view.backgroundColor = .clear }
        super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
    }

    private func resetCurrentViewController(refreshDataSource refresh: Bool = false) {
        currentViewController = viewControllers?.first
        if refresh || willRefreshDataSource {
            refreshDataSource()
        }
    }

    private func refreshDataSource() {
        dispatch(.mainAsync) { [self] in
            guard scrollPosition == scrollIdlePosition else {
                willRefreshDataSource = true
                return
            }
            let currentSource = dataSource
            dataSource = nil
            dataSource = currentSource
            willRefreshDataSource = false
        }
    }

    // MARK: - UIScrollViewDelegate

    public var isScrollInIdlePosition: Bool {
        scrollPosition == scrollIdlePosition
    }

    private var isDragging = false
    private let scrollIdlePosition = 0.5
    private var scrollPosition: CGFloat {
        guard let scroll else { return scrollIdlePosition }
        return (scroll.contentOffset.x) / (scroll.contentSize.width - scroll.bounds.width)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollPosition == scrollIdlePosition {
            if willRefreshDataSource { refreshDataSource() }
            if !isDragging { return }
        }
        let direction: UIPageViewController.NavigationDirection = scrollPosition > scrollIdlePosition ? .forward : .reverse
        let progress = clamp(abs(0.5 - scrollPosition) * 2, min: 0, max: 1)
        didTransition.fire(TransitionInfo(currentViewController: currentViewController,
                                          pendingViewController: pendingViewController,
                                          transitionProgress: progress,
                                          direction: direction,
                                          isDrag: isDragging))
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            resetCurrentViewController()
            isDragging = false
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetCurrentViewController()
        isDragging = false
    }
}
