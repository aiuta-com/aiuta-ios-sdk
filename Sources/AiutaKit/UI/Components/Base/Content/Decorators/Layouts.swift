//
// Created by nGrey on 25.03.2023.
//

import UIKit

@MainActor public final class Layouts {
    private static let keyboardWatcher = KeyboardLayout()

    public var isEnabled = true

    private let view: UIView
    private weak var content: ContentBase?

    public let safe: SafeArea

    init(_ content: ContentBase, target: UIView) {
        view = target
        self.content = content
        safe = SafeArea(target: view)
    }

    public var left: CGFloat {
        frame.origin.x
    }

    public var right: CGFloat {
        (view.superview?.bounds.width ?? 0) - width - left
    }

    public var top: CGFloat {
        frame.origin.y
    }

    public var bottom: CGFloat {
        (view.superview?.bounds.height ?? 0) - height - top
    }

    public var leftPin: CGFloat {
        (view.superview?.bounds.width ?? 0) - left
    }

    public var rightPin: CGFloat {
        left + width
    }

    public var topPin: CGFloat {
        (view.superview?.bounds.height ?? 0) - top
    }

    public var bottomPin: CGFloat {
        top + height
    }

    public var centerX: CGFloat {
        left + width / 2 - boundary.width / 2
    }

    public var centerY: CGFloat {
        top + height / 2 - boundary.height / 2
    }

    public var center: CGPoint {
        CGPoint(x: centerX, y: centerY)
    }

    public var width: CGFloat {
        size.width
    }

    public var height: CGFloat {
        size.height
    }

    public var size: CGSize {
        bounds.size
    }

    public var frame: CGRect {
        view.frame
    }

    public var bounds: CGRect {
        view.bounds
    }

    public var boundary: CGRect {
        view.superview?.bounds ?? frame
    }

    public var screen: CGRect {
        view.window?.bounds ?? UIScreen.main.bounds
    }

    public var aspectRatio: CGFloat {
        size.aspectRatio
    }

    public var root: CGRect {
        var root = content
        while (root?.parent).isSome {
            root = root?.parent
        }
        return root?.container.bounds ?? screen
    }

    public var keyboard: KeyboardLayout {
        Layouts.keyboardWatcher
    }

    public var visible: CGRect {
        guard let root = findRoot() else { return .zero }
        return root.convert(root.bounds.intersection(view.convert(view.bounds, to: root)), to: view)
    }

    public var screenFrame: CGRect {
        guard let root = findRoot() else { return .zero }
        return view.convert(view.bounds, to: root)
    }

    public var visibleScreenFrame: CGRect {
        guard let root = findRoot() else { return .zero }
        return view.convert(visible, to: root)
    }

    public var insets: UIEdgeInsets = .zero

    private func findRoot() -> UIView? {
        var candidate = content
        while let test = candidate, !test.isRoot, test.parent.isSome { candidate = test.parent }
        return candidate?.container
    }

    public func make(_ closure: (_ make: inout LayoutMaker) -> Void) {
        guard let superview = view.superview else { return }
        var maker = LayoutMaker()
        maker.update(view.frame, in: superview.bounds.size)
        closure(&maker)
        if maker.maxWidth.isSome {
            make { $0.width = screen.width }
            view.sizeToFit()
            maker.update(view.frame, in: superview.bounds.size)
            closure(&maker)
        }
        if maker.maxHeight.isSome {
            make { $0.height = screen.height }
            view.sizeToFit()
            maker.update(view.frame, in: superview.bounds.size)
            closure(&maker)
        }
        let rect = maker.build()
        if let scale = maker.scale {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        if view.bounds.size != rect.size {
            view.frame.size = rect.size
        }
        if let rotation = maker.rotation {
            view.transform = CGAffineTransform(rotationAngle: rotation.radians)
        }
        view.center = CGPoint(x: rect.midX, y: rect.midY)
        if let radius = maker.radius {
            view.cornerRadius = radius
            if #available(iOS 13.0, *) {
                if let curve = maker.curve {
                    view.cornerCurve = curve
                } else if rect.size.width == 2 * radius && rect.size.height == 2 * radius {
                    view.cornerCurve = .circular
                } else {
                    view.cornerCurve = .continuous
                }
            }
        }
    }
}

private let sharedAdjustments = SafeArea.Adjustments()

public final class SafeArea {
    public final class Adjustments: PropertyStoring {}

    private let view: UIView

    init(target: UIView) {
        view = target
    }

    public var guide: UILayoutGuide {
        if isMac { return UILayoutGuide() }
        return view.safeAreaLayoutGuide
    }

    public var margins: UIEdgeInsets {
        view.insetsLayoutMarginsFromSafeArea = false
        return view.layoutMargins
    }

    public var safeMargins: UIEdgeInsets {
        view.insetsLayoutMarginsFromSafeArea = true
        return view.layoutMargins
    }

    public var insets: UIEdgeInsets {
        if isMac { return .zero }
        var target = view
        while let superview = target.superview {
            target = superview
        }
        return target.safeAreaInsets
    }

    public var adjustments: Adjustments {
        sharedAdjustments
    }

    public var isMac: Bool {
        if #available(iOS 14.0, *) {
            return ProcessInfo.processInfo.isiOSAppOnMac
        } else {
            return false
        }
    }
}

public struct LayoutMaker {
    public var left: CGFloat {
        get { x }
        set {
            isLeftExplicit = true
            if isRightExplicit {
                w = sw - right - newValue
                clampSize()
            } else {
                x = newValue
            }
        }
    }

    public var right: CGFloat {
        get { sw - w - x }
        set {
            isRightExplicit = true
            if isLeftExplicit {
                w = sw - newValue - x
                clampSize()
            } else {
                x = sw - w - newValue
            }
        }
    }

    public var leftRight: CGFloat {
        get { left }
        set {
            left = newValue
            right = newValue
        }
    }

    public var top: CGFloat {
        get { y }
        set {
            isTopExplicit = true
            if isBottomExplicit {
                h = sh - bottom - newValue
                clampSize()
            } else {
                y = newValue
            }
        }
    }

    public var bottom: CGFloat {
        get { sh - h - y }
        set {
            isBottomExplicit = true
            if isTopExplicit {
                h = sh - newValue - y
                clampSize()
            } else {
                y = sh - h - newValue
            }
        }
    }

    public var topBottom: CGFloat {
        get { top }
        set {
            top = newValue
            bottom = newValue
        }
    }

    public var inset: CGFloat {
        get { 0 }
        set {
            left = newValue
            right = newValue
            top = newValue
            bottom = newValue
        }
    }

    public var centerX: CGFloat {
        get { x + w / 2 - sw / 2 }
        set { x = newValue - w / 2 + sw / 2 }
    }

    public var centerY: CGFloat {
        get { y + h / 2 - sh / 2 }
        set { y = newValue - h / 2 + sh / 2 }
    }

    public var center: CGPoint {
        get { CGPoint(x: centerX, y: centerY) }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }

    public var centerLeft: CGFloat {
        get { x + w / 2 }
        set { x = newValue - w / 2 }
    }

    public var centerRight: CGFloat {
        get { sw - x - w / 2 }
        set { x = sw - newValue - w / 2 }
    }

    public var centerTop: CGFloat {
        get { y + h / 2 }
        set { y = newValue - h / 2 }
    }

    public var centerBottom: CGFloat {
        get { sh - y - h / 2 }
        set { y = sh - newValue - h / 2 }
    }

    public var width: CGFloat {
        get { w }
        set {
            w = newValue
            clampSize()
        }
    }

    public var height: CGFloat {
        get { h }
        set {
            h = newValue
            clampSize()
        }
    }

    public var size: CGSize {
        get { CGSize(width: w, height: h) }
        set {
            w = newValue.width
            h = newValue.height
            clampSize()
        }
    }

    public var circle: CGFloat? {
        get {
            guard let radius else { return nil }
            return radius * 2
        }
        set {
            guard let newValue else {
                radius = nil
                return
            }
            radius = newValue / 2
            size = .init(square: newValue)
        }
    }

    public var minWidth: CGFloat? { didSet { clampSize() } }
    public var maxWidth: CGFloat? { didSet { clampSize() } }
    public var minHeight: CGFloat? { didSet { clampSize() } }
    public var maxHeight: CGFloat? { didSet { clampSize() } }

    public var frame: CGRect {
        get { CGRect(x: x, y: y, width: w, height: h) }
        set {
            x = newValue.origin.x
            y = newValue.origin.y
            w = newValue.size.width
            h = newValue.size.height
            clampSize()
        }
    }

    public mutating func fit(_ other: CGSize?) {
        frame = frame.fit(other)
    }

    public mutating func fill(_ other: CGSize?) {
        frame = frame.fill(other)
    }

    public var scale: CGFloat? = nil
    public var rotation: CGFloat? = nil
    public var radius: CGFloat? = nil
    public var curve: CALayerCornerCurve? = nil

    private var x: CGFloat = 0
    private var y: CGFloat = 0
    private var w: CGFloat = 0
    private var h: CGFloat = 0
    private var sw: CGFloat = 0
    private var sh: CGFloat = 0

    private var isLeftExplicit = false
    private var isRightExplicit = false
    private var isTopExplicit = false
    private var isBottomExplicit = false

    @discardableResult
    fileprivate mutating func update(_ frame: CGRect, in bounds: CGSize) -> Self {
        x = frame.origin.x
        y = frame.origin.y
        w = frame.size.width
        h = frame.size.height
        sw = bounds.width
        sh = bounds.height
        return self
    }

    fileprivate func build() -> CGRect {
        CGRect(x: x, y: y, width: w, height: h)
    }

    private mutating func clampSize() {
        w = clamp(value: w, min: minWidth, max: maxWidth)
        h = clamp(value: h, min: minHeight, max: maxHeight)
    }

    private func clamp(value: CGFloat, min: CGFloat?, max: CGFloat?) -> CGFloat {
        var result = value
        if let min, result < min { result = min }
        if let max, result > max { result = max }
        return result
    }
}

public final class KeyboardLayout {
    public private(set) var frame: CGRect = .zero
    public private(set) var bounds: CGRect = .zero
    public var height: CGFloat { frame.height }
    public var isVisible: Bool { height > 0 }

    @notification(UIResponder.keyboardWillShowNotification)
    private var keyboardWillShow: Signal<Notification>

    @notification(UIResponder.keyboardWillHideNotification)
    private var keyboardWillHide: Signal<Notification>

    @notification(UIResponder.keyboardWillChangeFrameNotification)
    private var keyboardWillChangeFrame: Signal<Notification>

    init(_ notificationCeneter: NotificationCenter = .default) {
        let keyboardHandler = { [unowned self] (notification: Notification) in
            let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            guard let keyboardFrame = keyboardFrameValue?.cgRectValue else { return }
            frame = keyboardFrame.intersection(UIScreen.main.bounds)
            bounds = keyboardFrame
        }

        keyboardWillShow.subscribe(with: self, callback: keyboardHandler)
        keyboardWillHide.subscribe(with: self, callback: keyboardHandler)
        keyboardWillChangeFrame.subscribe(with: self, callback: keyboardHandler)
    }
}
