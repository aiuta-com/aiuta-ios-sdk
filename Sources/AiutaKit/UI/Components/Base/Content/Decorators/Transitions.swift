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

import Resolver
import UIKit

@_spi(Aiuta) public final class Transitions {
    @Injected
    private var heroic: Heroic
    private let view: UIView

    init(target: UIView) {
        view = target
    }

    public var reference: TransitionRef? {
        didSet {
            guard isReferenceActive else {
                heroic.setId(nil, for: view)
                return
            }
            heroic.setId(reference?.transitionId, for: view)
        }
    }

    public var isReferenceActive = true {
        didSet {
            heroic.setId(isReferenceActive ? reference?.transitionId : nil, for: view)
        }
    }

    public func enableReferenceForNextTransition() {
        isReferenceActive = true

        // TODO: wait for hero complete, not delay
        delay(.thirdOfSecond) { [weak self] in
            self?.isReferenceActive = false
        }
    }

    public func make(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker(when: .always)
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        modifiers = [maker]
    }

    public func whenAppear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker(when: .appearing)
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(maker)
    }

    public func whenDisappear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker(when: .disappearing)
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(maker)
    }

    public func whenDismissing(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker(when: .dismissing)
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(maker)
    }

    public func whenPresenting(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker(when: .presenting)
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(maker)
    }

    public func remove() {
        modifiers = nil
    }

    private var modifiers: [TransitionMaker]? {
        didSet {
            guard isActive else {
                heroic.setModifiers(nil, for: view)
                return
            }
            heroic.setModifiers(modifiers, for: view)
        }
    }

    public var isActive: Bool = true {
        didSet {
            heroic.setModifiers(isActive ? modifiers : nil, for: view)
        }
    }
}

@_spi(Aiuta) public struct TransitionMaker {
    public let when: When
    public var reference: TransitionRef?

    public var position: CGPoint?
    public var size: CGSize?
    public var transform: CATransform3D?
    public var opacity: Float?
    public var cornerRadius: CGFloat?
    public var backgroundColor: CGColor?
    public var zPosition: CGFloat?
    public var anchorPoint: CGPoint?

    public var contentsRect: CGRect?
    public var contentsScale: CGFloat?

    public var borderWidth: CGFloat?
    public var borderColor: CGColor?

    public var shadowColor: CGColor?
    public var shadowOpacity: Float?
    public var shadowOffset: CGSize?
    public var shadowRadius: CGFloat?
    public var shadowPath: CGPath?
    public var masksToBounds: Bool?
    public var displayShadow: Bool = true

    public var overlay: (color: CGColor, opacity: CGFloat)?

    public var spring: (CGFloat, CGFloat)?
    public var delay: TimeInterval = 0
    public var duration: AsyncDelayTime?
    public var timingFunction: CAMediaTimingFunction?

    public var arc: CGFloat?
    public var source: String?
    public var cascade: (TimeInterval, CascadeDirection, Bool)?

    public var ignoreSubviewModifiers: Bool?
    public var coordinateSpace: CoordinateSpace?
    public var useScaleBasedSizeChange: Bool?
    public var snapshotType: SnapshotType?

    public var nonFade: Bool = false
    public var forceAnimate: Bool = false

    public mutating func fade() {
        opacity = 0
    }

    public mutating func noFade() {
        nonFade = true
    }

    public mutating func global() {
        coordinateSpace = .global
    }

    public mutating func perspective(_ perspective: CGFloat) {
        var transform = transform ?? CATransform3DIdentity
        transform.m34 = 1.0 / -perspective
        self.transform = transform
    }

    public mutating func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) {
        transform = CATransform3DScale(transform ?? CATransform3DIdentity, x, y, z)
    }

    public mutating func scale(_ xy: CGFloat) {
        scale(x: xy, y: xy)
    }

    public mutating func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) {
        transform = CATransform3DTranslate(transform ?? CATransform3DIdentity, x, y, z)
    }

    public mutating func translate(_ point: CGPoint, z: CGFloat = 0) {
        translate(x: point.x, y: point.y, z: z)
    }

    public mutating func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) {
        transform = CATransform3DRotate(transform ?? CATransform3DIdentity, x, 1, 0, 0)
        transform = CATransform3DRotate(transform!, y, 0, 1, 0)
        transform = CATransform3DRotate(transform!, z, 0, 0, 1)
    }

    public mutating func rotate(_ point: CGPoint, z: CGFloat = 0) {
        rotate(x: point.x, y: point.y, z: z)
    }

    public mutating func rotate(_ z: CGFloat) {
        rotate(z: z)
    }
}

@_spi(Aiuta) extension TransitionMaker {
    @_spi(Aiuta) public enum When {
        case always
        case appearing, disappearing
        case dismissing, presenting
    }

    @_spi(Aiuta) public enum CoordinateSpace {
        case global
        case local
    }

    @_spi(Aiuta) public enum SnapshotType {
        case optimized
        case normal
        case layerRender
        case noSnapshot
    }

    @_spi(Aiuta) public enum CascadeDirection {
        case topToBottom
        case bottomToTop
        case leftToRight
        case rightToLeft
        case radial(center: CGPoint)
        case inverseRadial(center: CGPoint)
    }
}
