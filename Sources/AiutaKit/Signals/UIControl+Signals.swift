//
//  Copyright (c) 2014 - 2017 Tuomas Artman. All rights reserved.
//

import ObjectiveC
import UIKit

/// Extends UIControl with signals for all ui control events.
@_spi(Aiuta) public extension UIControl {
    /// A signal that fires for each touch down control event.
    var onTouchDown: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDown)
    }

    /// A signal that fires for each touch down repeat control event.
    var onTouchDownRepeat: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDownRepeat)
    }

    /// A signal that fires for each touch drag inside control event.
    var onTouchDragInside: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDragInside)
    }

    /// A signal that fires for each touch drag outside control event.
    var onTouchDragOutside: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDragOutside)
    }

    /// A signal that fires for each touch drag enter control event.
    var onTouchDragEnter: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDragEnter)
    }

    /// A signal that fires for each touch drag exit control event.
    var onTouchDragExit: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchDragExit)
    }

    /// A signal that fires for each touch up inside control event.
    var onTouchUpInside: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchUpInside)
    }

    /// A signal that fires for each touch up outside control event.
    var onTouchUpOutside: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchUpOutside)
    }

    /// A signal that fires for each touch cancel control event.
    var onTouchCancel: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.touchCancel)
    }

    /// A signal that fires for each value changed control event.
    var onValueChanged: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.valueChanged)
    }

    /// A signal that fires for each editing did begin control event.
    var onEditingDidBegin: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.editingDidBegin)
    }

    /// A signal that fires for each editing changed control event.
    var onEditingChanged: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.editingChanged)
    }

    /// A signal that fires for each editing did end control event.
    var onEditingDidEnd: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.editingDidEnd)
    }

    /// A signal that fires for each editing did end on exit control event.
    var onEditingDidEndOnExit: Signal<Void> {
        return getOrCreateSignalForUIControlEvent(.editingDidEndOnExit)
    }
}

// MARK: - Private interface

private extension UIControl {
    struct AssociatedKeys {
        static var SignalDictionaryKey: Void?
    }

    static let eventToKey: [UIControl.Event.RawValue: NSString] = [
        UIControl.Event.touchDown.rawValue: "TouchDown",
        UIControl.Event.touchDownRepeat.rawValue: "TouchDownRepeat",
        UIControl.Event.touchDragInside.rawValue: "TouchDragInside",
        UIControl.Event.touchDragOutside.rawValue: "TouchDragOutside",
        UIControl.Event.touchDragEnter.rawValue: "TouchDragEnter",
        UIControl.Event.touchDragExit.rawValue: "TouchDragExit",
        UIControl.Event.touchUpInside.rawValue: "TouchUpInside",
        UIControl.Event.touchUpOutside.rawValue: "TouchUpOutside",
        UIControl.Event.touchCancel.rawValue: "TouchCancel",
        UIControl.Event.valueChanged.rawValue: "ValueChanged",
        UIControl.Event.editingDidBegin.rawValue: "EditingDidBegin",
        UIControl.Event.editingChanged.rawValue: "EditingChanged",
        UIControl.Event.editingDidEnd.rawValue: "EditingDidEnd",
        UIControl.Event.editingDidEndOnExit.rawValue: "EditingDidEndOnExit",
    ]

    func getOrCreateSignalForUIControlEvent(_ event: UIControl.Event) -> Signal<Void> {
        guard let key = UIControl.eventToKey[event.rawValue] else {
            assertionFailure("Event type is not handled")
            return Signal()
        }

        let dictionary = getAssociatedProperty(&AssociatedKeys.SignalDictionaryKey, ofType: NSMutableDictionary.self)
            ?? setAssociatedProperty(&AssociatedKeys.SignalDictionaryKey, newValue: NSMutableDictionary(), policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        if let signal = dictionary[key] as? Signal<Void> {
            return signal
        } else {
            let signal = Signal<Void>()
            dictionary[key] = signal
            addTarget(self, action: Selector("eventHandler\(key)"), for: event)
            return signal
        }
    }

    func handleUIControlEvent(_ uiControlEvent: UIControl.Event) {
        getOrCreateSignalForUIControlEvent(uiControlEvent).fire()
    }

    @objc private dynamic func eventHandlerTouchDown() {
        handleUIControlEvent(.touchDown)
    }

    @objc private dynamic func eventHandlerTouchDownRepeat() {
        handleUIControlEvent(.touchDownRepeat)
    }

    @objc private dynamic func eventHandlerTouchDragInside() {
        handleUIControlEvent(.touchDragInside)
    }

    @objc private dynamic func eventHandlerTouchDragOutside() {
        handleUIControlEvent(.touchDragOutside)
    }

    @objc private dynamic func eventHandlerTouchDragEnter() {
        handleUIControlEvent(.touchDragEnter)
    }

    @objc private dynamic func eventHandlerTouchDragExit() {
        handleUIControlEvent(.touchDragExit)
    }

    @objc private dynamic func eventHandlerTouchUpInside() {
        handleUIControlEvent(.touchUpInside)
    }

    @objc private dynamic func eventHandlerTouchUpOutside() {
        handleUIControlEvent(.touchUpOutside)
    }

    @objc private dynamic func eventHandlerTouchCancel() {
        handleUIControlEvent(.touchCancel)
    }

    @objc private dynamic func eventHandlerValueChanged() {
        handleUIControlEvent(.valueChanged)
    }

    @objc private dynamic func eventHandlerEditingDidBegin() {
        handleUIControlEvent(.editingDidBegin)
    }

    @objc private dynamic func eventHandlerEditingChanged() {
        handleUIControlEvent(.editingChanged)
    }

    @objc private dynamic func eventHandlerEditingDidEnd() {
        handleUIControlEvent(.editingDidEnd)
    }

    @objc private dynamic func eventHandlerEditingDidEndOnExit() {
        handleUIControlEvent(.editingDidEndOnExit)
    }
}
