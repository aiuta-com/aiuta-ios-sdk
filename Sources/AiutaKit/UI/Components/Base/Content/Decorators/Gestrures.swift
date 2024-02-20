//
//  Created by nGrey on 05.07.2023.
//

import UIKit

public final class Gestures {
    private var tap: GestureProxy<UITapGestureRecognizer>?
    private var doubleTap: GestureProxy<UITapGestureRecognizer>?
    private var longPress: GestureProxy<UILongPressGestureRecognizer>?

    private var pan: GestureProxy<PanDirectionGestureRecognizer>?
    private var panV: GestureProxy<PanDirectionGestureRecognizer>?
    private var panH: GestureProxy<PanDirectionGestureRecognizer>?

    private var pinch: GestureProxy<UIPinchGestureRecognizer>?

    private var swipeR: GestureProxy<UISwipeGestureRecognizer>?
    private var swipeL: GestureProxy<UISwipeGestureRecognizer>?
    private var swipeU: GestureProxy<UISwipeGestureRecognizer>?
    private var swipeD: GestureProxy<UISwipeGestureRecognizer>?

    private let view: UIView

    init(target: UIView) {
        view = target
    }

    deinit {
        tap?.free()
        doubleTap?.free()
        longPress?.free()

        pan?.free()
        panV?.free()
        panH?.free()

        pinch?.free()
    }
}

// MARK: Taps

public extension Gestures {
    func onTap(with target: AnyObject, callback: @escaping Signal<UITapGestureRecognizer>.SignalCallback) {
        on(&tap, target: target, callback: callback)
    }

    func offTap(for target: AnyObject) {
        off(&tap, target: target)
    }
}

public extension Gestures {
    func onDoubleTap(with target: AnyObject, callback: @escaping Signal<UITapGestureRecognizer>.SignalCallback) {
        on(&doubleTap, target: target, callback: callback) { doubleTap in
            doubleTap.numberOfTapsRequired = 2
        }
    }

    func offDoubleTap(for target: AnyObject) {
        off(&doubleTap, target: target)
    }
}

public extension Gestures {
    func onLongPress(with target: AnyObject, callback: @escaping Signal<UILongPressGestureRecognizer>.SignalCallback) {
        on(&longPress, target: target, callback: callback) { longPress in
            longPress.minimumPressDuration = 2
        }
    }

    func offLongPress(for target: AnyObject) {
        off(&longPress, target: target)
    }
}

// MARK: Pan

public extension Gestures {
    func onPan(_ direction: PanDirectionGestureRecognizer.PanDirection, with target: AnyObject, callback: @escaping Signal<PanDirectionGestureRecognizer>.SignalCallback) {
        let config = { (pan: PanDirectionGestureRecognizer) in
            pan.direction = direction
            if #available(iOS 13.4, *) { pan.allowedScrollTypesMask = .continuous }
        }
        switch direction {
            case .any: on(&pan, target: target, callback: callback, configurator: config)
            case .vertical: on(&panV, target: target, callback: callback, configurator: config)
            case .horizontal: on(&panH, target: target, callback: callback, configurator: config)
        }
    }

    func offPan(_ direction: PanDirectionGestureRecognizer.PanDirection, for target: AnyObject) {
        switch direction {
            case .any: off(&pan, target: target)
            case .vertical: off(&panV, target: target)
            case .horizontal: off(&panH, target: target)
        }
    }
}

// MARK: Pinch

public extension Gestures {
    func onPinch(with target: AnyObject, callback: @escaping Signal<UIPinchGestureRecognizer>.SignalCallback) {
        on(&pinch, target: target, callback: callback)
    }

    func offPinch(for target: AnyObject) {
        off(&pinch, target: target)
    }
}

// MARK: Swipe

public extension Gestures {
    func onSwipe(_ direction: UISwipeGestureRecognizer.Direction, with target: AnyObject, callback: @escaping Signal<UISwipeGestureRecognizer>.SignalCallback) {
        let config = { (swipe: UISwipeGestureRecognizer) in
            swipe.direction = direction
        }
        switch direction {
            case .right: on(&swipeR, target: target, callback: callback, configurator: config)
            case .left: on(&swipeL, target: target, callback: callback, configurator: config)
            case .up: on(&swipeU, target: target, callback: callback, configurator: config)
            case .down: on(&swipeD, target: target, callback: callback, configurator: config)
            default: break
        }
    }

    func offSwipe(_ direction: UISwipeGestureRecognizer.Direction, for target: AnyObject) {
        switch direction {
            case .right: off(&swipeR, target: target)
            case .left: off(&swipeL, target: target)
            case .up: off(&swipeU, target: target)
            case .down: off(&swipeD, target: target)
            default: break
        }
    }
}

// MARK: Add/Remove Gesture Recognizers

private extension Gestures {
    func on<GestureRecognizer: UIGestureRecognizer>(_ proxy: inout GestureProxy<GestureRecognizer>?,
                                                    target: AnyObject,
                                                    callback: @escaping Signal<GestureRecognizer>.SignalCallback,
                                                    configurator: ((GestureRecognizer) -> Void)? = nil) {
        if proxy.isNil { proxy = GestureProxy(target: view, configurator: configurator) }
        proxy?.signal.subscribe(with: target, callback: callback)
    }

    func off<GestureRecognizer: UIGestureRecognizer>(_ proxy: inout GestureProxy<GestureRecognizer>?,
                                                     target: AnyObject) {
        proxy?.signal.cancelSubscription(for: target)
        if (proxy?.signal.observers.isEmpty).isTrue {
            proxy?.free()
            proxy = nil
        }
    }
}

// MARK: Gesture Recognizer Proxy

private final class GestureProxy<GestureRecognizer: UIGestureRecognizer>: GestureHandler {
    fileprivate let signal = Signal<GestureRecognizer>()
    private let gestureRecognizer: GestureRecognizer

    init(target: UIView, configurator: ((GestureRecognizer) -> Void)?) {
        gestureRecognizer = GestureRecognizer()
        configurator?(gestureRecognizer)
        super.init(target, gestureRecognizer)
    }

    override func trigger() {
        signal.fire(gestureRecognizer)
    }
}

private class GestureHandler: NSObject {
    private weak var target: UIView?
    private let recognizer: UIGestureRecognizer

    init(_ target: UIView, _ recognizer: UIGestureRecognizer) {
        self.recognizer = recognizer
        self.target = target
        super.init()
        recognizer.delegate = self
        recognizer.addTarget(self, action: #selector(GestureHandler.recognized(_:)))
        target.addGestureRecognizer(recognizer)
    }

    fileprivate func free() {
        target?.removeGestureRecognizer(recognizer)
        recognizer.removeTarget(self, action: #selector(GestureHandler.recognized(_:)))
    }

    @objc func recognized(_: UIGestureRecognizer) {
        trigger()
    }

    func trigger() { }
}

extension GestureHandler: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is PanDirectionGestureRecognizer {
            return (gestureRecognizer as! PanDirectionGestureRecognizer).canBegin()
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
}

// MARK: Directional Pan Gesture Recognizer

public final class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    public enum PanDirection {
        case any
        case vertical
        case horizontal
    }

    public var direction: PanDirection = .any

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if state == .began, !canBegin() { state = .cancelled }
    }

    fileprivate func canBegin() -> Bool {
        let vel = velocity(in: view)
        var match: Bool
        switch direction {
            case .horizontal where abs(vel.y) > abs(vel.x): match = false
            case .vertical where abs(vel.x) > abs(vel.y): match = false
            default: match = true
        }
        return match
    }
}
