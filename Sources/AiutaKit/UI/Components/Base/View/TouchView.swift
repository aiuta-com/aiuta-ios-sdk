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

import UIKit

@_spi(Aiuta) open class TouchView: PlainView {
    public let onTouchDown = Signal<Void>()
    public let onTouchUp = Signal<Void>()
    public let onTouchUpInside = Signal<Void>()
    public let onLongTouch = Signal<Void>()

    private var isOver = false
    public var pressedOpacity: Float? = 0.7
    public internal(set) var isPressed = false {
        didSet {
            guard oldValue != isPressed else { return }
            if isPressed {
                onTouchDown.fire()
                checkLongTouchConditions()
            } else {
                if !isLongTouched { onTouchUp.fire() }
                isLongTouched = false
                longTouchToken.cancel()
            }
        }
    }

    public var hasToggle = false
    public let onToggle = Signal<Bool>()
    public var isToggled: Bool = false {
        didSet {
            guard oldValue != isToggled else { return }
            onToggle.fire(isToggled)
        }
    }

    public var longTouchTime: AsyncDelayTime?
    private var isLongTouched = false
    private let longTouchToken = AutoCancellationToken()

    public var coolDownTime: AsyncDelayTime? = .quarterOfSecond
    private var isCoolingDown = false
    private let coolDownToken = AutoCancellationToken()

    public func coolDown() {
        if let coolDown = coolDownTime {
            isCoolingDown = true
            coolDownToken << delay(coolDown) { self.isCoolingDown = false }
        }
    }
}

extension TouchView {
    private func checkLongTouchConditions() {
        if longTouchTime.isNil && !onLongTouch.observers.isEmpty {
            longTouchTime = .custom(0.6)
        }
        if let longTouchTime {
            longTouchToken << delay(longTouchTime) { [weak self] in
                guard let self, self.isOver else { return }
                haptic(impact: .heavy)
                self.isLongTouched = true
                self.onLongTouch.fire()
            }
        }
    }
}

extension TouchView {
    override open func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        if isCoolingDown { return }
        isPressed = true
        isOver = true
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        if isCoolingDown { return }
        isPressed = true
        guard let touchPoint = touches.first?.location(in: self) else { return }
        isOver = bounds.contains(touchPoint)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        if isCoolingDown { return }
        let willFireTouchUpInside = !isLongTouched
        isPressed = false
        isOver = false
        guard let touchPoint = touches.first?.location(in: self) else { return }
        if bounds.contains(touchPoint) {
            if hasToggle { isToggled.toggle() }
            if willFireTouchUpInside { onTouchUpInside.fire() }
            coolDown()
        }
    }

    override open func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        if isCoolingDown { return }
        isPressed = false
        isOver = false
    }
}
