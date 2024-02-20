//
// Created by nGrey on 28.02.2023.
//

import Hero
import UIKit

public final class Transitions {
    private let view: UIView

    init(target: UIView) {
        view = target
    }

    public var reference: TransitionRef? {
        didSet {
            guard isReferenceActive else {
                view.hero.id = nil
                return
            }
            view.hero.id = reference?.transitionId
        }
    }

    public var isReferenceActive = true {
        didSet {
            view.hero.id = isReferenceActive ? reference?.transitionId : nil
        }
    }
    
    public func enableReferenceForNextTransition() {
        isReferenceActive = true
        
        //TODO: wait for hero complete, not delay
        delay(.thirdOfSecond) { [weak self] in
            self?.isReferenceActive = false
        }
    }

    public func make(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        modifiers = [HeroModifier { targetState in
            maker.write(to: &targetState)
        }]
    }

    public func whenAppear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenAppearing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }

    public func whenDisappear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenDisappearing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    public func whenDismissing(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenDismissing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    public func whenPresenting(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenPresenting(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    public func remove() {
        modifiers = nil
    }

    private var modifiers: [HeroModifier]? {
        didSet {
            guard isActive else {
                view.hero.modifiers = nil
                return
            }
            view.hero.modifiers = modifiers
        }
    }

    public var isActive: Bool = true {
        didSet {
            view.hero.modifiers = isActive ? modifiers : nil
        }
    }
}

public struct TransitionMaker {
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
    public var coordinateSpace: HeroCoordinateSpace?
    public var useScaleBasedSizeChange: Bool?
    public var snapshotType: HeroSnapshotType?

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

    func write(to target: inout HeroTargetState) {
        target.position = position
        target.size = size
        target.transform = transform
        target.opacity = opacity
        target.cornerRadius = cornerRadius
        target.backgroundColor = backgroundColor
        target.zPosition = zPosition
        target.anchorPoint = anchorPoint
        target.contentsRect = contentsRect
        target.contentsScale = contentsScale
        target.borderWidth = contentsScale
        target.borderColor = borderColor
        target.shadowColor = shadowColor
        target.shadowOpacity = shadowOpacity
        target.shadowPath = shadowPath
        target.masksToBounds = masksToBounds
        target.displayShadow = displayShadow
        target.overlay = overlay
        target.spring = spring
        target.delay = delay
        target.duration = duration?.seconds
        target.timingFunction = timingFunction
        target.arc = arc
        target.source = source
        target.cascade = cascade
        target.ignoreSubviewModifiers = ignoreSubviewModifiers
        target.coordinateSpace = coordinateSpace
        target.useScaleBasedSizeChange = useScaleBasedSizeChange
        target.snapshotType = snapshotType
        target.nonFade = nonFade
        target.forceAnimate = forceAnimate
    }
}
