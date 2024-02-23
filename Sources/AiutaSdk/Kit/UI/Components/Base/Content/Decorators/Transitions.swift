//
// Created by nGrey on 28.02.2023.
//

import Hero
import UIKit

final class Transitions {
    private let view: UIView

    init(target: UIView) {
        view = target
    }

    var reference: TransitionRef? {
        didSet {
            guard isReferenceActive else {
                view.hero.id = nil
                return
            }
            view.hero.id = reference?.transitionId
        }
    }

    var isReferenceActive = true {
        didSet {
            view.hero.id = isReferenceActive ? reference?.transitionId : nil
        }
    }
    
    func enableReferenceForNextTransition() {
        isReferenceActive = true
        
        //TODO: wait for hero complete, not delay
        delay(.thirdOfSecond) { [weak self] in
            self?.isReferenceActive = false
        }
    }

    func make(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        modifiers = [HeroModifier { targetState in
            maker.write(to: &targetState)
        }]
    }

    func whenAppear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenAppearing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }

    func whenDisappear(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenDisappearing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    func whenDismissing(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenDismissing(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    func whenPresenting(_ closure: (_ make: inout TransitionMaker) -> Void) {
        var maker = TransitionMaker()
        closure(&maker)
        if let ref = maker.reference { reference = ref }
        if modifiers.isNil { modifiers = [] }
        modifiers?.append(HeroModifier.whenPresenting(HeroModifier { targetState in
            maker.write(to: &targetState)
        }))
    }
    
    func remove() {
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

    var isActive: Bool = true {
        didSet {
            view.hero.modifiers = isActive ? modifiers : nil
        }
    }
}

struct TransitionMaker {
    var reference: TransitionRef?

    var position: CGPoint?
    var size: CGSize?
    var transform: CATransform3D?
    var opacity: Float?
    var cornerRadius: CGFloat?
    var backgroundColor: CGColor?
    var zPosition: CGFloat?
    var anchorPoint: CGPoint?

    var contentsRect: CGRect?
    var contentsScale: CGFloat?

    var borderWidth: CGFloat?
    var borderColor: CGColor?

    var shadowColor: CGColor?
    var shadowOpacity: Float?
    var shadowOffset: CGSize?
    var shadowRadius: CGFloat?
    var shadowPath: CGPath?
    var masksToBounds: Bool?
    var displayShadow: Bool = true

    var overlay: (color: CGColor, opacity: CGFloat)?

    var spring: (CGFloat, CGFloat)?
    var delay: TimeInterval = 0
    var duration: AsyncDelayTime?
    var timingFunction: CAMediaTimingFunction?

    var arc: CGFloat?
    var source: String?
    var cascade: (TimeInterval, CascadeDirection, Bool)?

    var ignoreSubviewModifiers: Bool?
    var coordinateSpace: HeroCoordinateSpace?
    var useScaleBasedSizeChange: Bool?
    var snapshotType: HeroSnapshotType?

    var nonFade: Bool = false
    var forceAnimate: Bool = false

    mutating func fade() {
        opacity = 0
    }

    mutating func noFade() {
        nonFade = true
    }

    mutating func global() {
        coordinateSpace = .global
    }

    mutating func perspective(_ perspective: CGFloat) {
        var transform = transform ?? CATransform3DIdentity
        transform.m34 = 1.0 / -perspective
        self.transform = transform
    }

    mutating func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) {
        transform = CATransform3DScale(transform ?? CATransform3DIdentity, x, y, z)
    }

    mutating func scale(_ xy: CGFloat) {
        scale(x: xy, y: xy)
    }

    mutating func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) {
        transform = CATransform3DTranslate(transform ?? CATransform3DIdentity, x, y, z)
    }

    mutating func translate(_ point: CGPoint, z: CGFloat = 0) {
        translate(x: point.x, y: point.y, z: z)
    }

    mutating func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) {
        transform = CATransform3DRotate(transform ?? CATransform3DIdentity, x, 1, 0, 0)
        transform = CATransform3DRotate(transform!, y, 0, 1, 0)
        transform = CATransform3DRotate(transform!, z, 0, 0, 1)
    }

    mutating func rotate(_ point: CGPoint, z: CGFloat = 0) {
        rotate(x: point.x, y: point.y, z: z)
    }

    mutating func rotate(_ z: CGFloat) {
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
