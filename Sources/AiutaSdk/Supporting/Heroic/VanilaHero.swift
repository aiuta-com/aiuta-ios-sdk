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

@_spi(Aiuta) import AiutaKit
import Hero
import UIKit

@_spi(Aiuta) public final class VanilaHero: Heroic {
    @discardableResult
    public static func capture() -> Heroic {
        shared.capture()
    }

    private static let shared = VanilaHero()

    public var isTransitioning: Bool { Hero.shared.isTransitioning }
    public let willStartTransition = Signal<Void>()
    public let didCompleteTransition = Signal<Void>()
    private weak var transitionDelegate: HeroTransitionDelegate?

    @MainActor public func completeTransition() async {
        guard isTransitioning else { return }
        await withCheckedContinuation { continuation in
            didCompleteTransition.subscribeOnce(with: self) {
                continuation.resume()
            }
        }
    }

    public func setEnabled(_ value: Bool, for vc: UIViewController) {
        vc.hero.isEnabled = value
    }

    public func customize(for vc: UIViewController) {
        vc.hero.modalAnimationType = .selectBy(presenting: .fade,
                                               dismissing: .pull(direction: .right))
    }

    public func setId(_ value: String?, for view: UIView) {
        view.hero.id = value
    }

    public func setModifiers(_ value: [TransitionMaker]?, for view: UIView) {
        view.hero.modifiers = value?.map { maker in
            let modifier = HeroModifier { [self] targetState in
                write(maker, to: &targetState)
            }

            switch maker.when {
                case .always: return modifier
                case .appearing: return HeroModifier.whenAppearing(modifier)
                case .disappearing: return HeroModifier.whenDisappearing(modifier)
                case .dismissing: return HeroModifier.whenDismissing(modifier)
                case .presenting: return HeroModifier.whenPresenting(modifier)
            }
        }
    }

    public func copyAnimation(from viewController: UIViewController, to navigationController: UINavigationController?) {
        navigationController?.hero.navigationAnimationType = viewController.hero.modalAnimationType
    }

    public func replace(_ viewController: UIViewController, with other: UIViewController) {
        viewController.hero.replaceViewController(with: other)
    }

    public func update(percent: CGFloat) {
        Hero.shared.update(percent)
    }

    public func finish(animate: Bool) {
        Hero.shared.finish(animate: animate)
    }

    public func cancel(animate: Bool) {
        Hero.shared.cancel(animate: animate)
    }

    private init() { }

    private func capture() -> Heroic {
        guard Hero.shared.delegate !== self else { return self }
        transitionDelegate = Hero.shared.delegate
        trace("Inject vanila hero delegate")
        Hero.shared.delegate = self
        return self
    }
}

extension VanilaHero: HeroTransitionDelegate {
    public func heroTransition(_ hero: HeroTransition, didUpdate state: HeroTransitionState) {
        switch state {
            case .starting: willStartTransition.fire()
            case .completing: didCompleteTransition.fire()
            default: break
        }
        transitionDelegate?.heroTransition(hero, didUpdate: state)
    }

    public func heroTransition(_ hero: HeroTransition, didUpdate progress: Double) {
        transitionDelegate?.heroTransition(hero, didUpdate: progress)
    }
}

private extension VanilaHero {
    func write(_ maker: TransitionMaker, to target: inout HeroTargetState) {
        target.position = maker.position
        target.size = maker.size
        target.transform = maker.transform
        target.opacity = maker.opacity
        target.cornerRadius = maker.cornerRadius
        target.backgroundColor = maker.backgroundColor
        target.zPosition = maker.zPosition
        target.anchorPoint = maker.anchorPoint
        target.contentsRect = maker.contentsRect
        target.contentsScale = maker.contentsScale
        target.borderWidth = maker.contentsScale
        target.borderColor = maker.borderColor
        target.shadowColor = maker.shadowColor
        target.shadowOpacity = maker.shadowOpacity
        target.shadowPath = maker.shadowPath
        target.masksToBounds = maker.masksToBounds
        target.displayShadow = maker.displayShadow
        target.overlay = maker.overlay
        target.spring = maker.spring
        target.delay = maker.delay
        target.duration = maker.duration?.seconds
        target.timingFunction = maker.timingFunction
        target.arc = maker.arc
        target.source = maker.source
        target.cascade = mapCascade(maker.cascade)
        target.ignoreSubviewModifiers = maker.ignoreSubviewModifiers
        target.coordinateSpace = mapSpace(maker.coordinateSpace)
        target.useScaleBasedSizeChange = maker.useScaleBasedSizeChange
        target.snapshotType = mapSnapshot(maker.snapshotType)
        target.nonFade = maker.nonFade
        target.forceAnimate = maker.forceAnimate
    }

    func mapCascade(_ maker: (TimeInterval, TransitionMaker.CascadeDirection, Bool)?) -> (TimeInterval, CascadeDirection, Bool)? {
        guard let maker else { return nil }
        switch maker.1 {
            case .topToBottom: return (maker.0, .topToBottom, maker.2)
            case .bottomToTop: return (maker.0, .bottomToTop, maker.2)
            case .leftToRight: return (maker.0, .leftToRight, maker.2)
            case .rightToLeft: return (maker.0, .rightToLeft, maker.2)
            case let .radial(center: center): return (maker.0, .radial(center: center), maker.2)
            case let .inverseRadial(center: center): return (maker.0, .inverseRadial(center: center), maker.2)
        }
    }

    func mapSpace(_ maker: TransitionMaker.CoordinateSpace?) -> HeroCoordinateSpace? {
        guard let maker else { return nil }
        switch maker {
            case .global: return .global
            case .local: return .local
        }
    }

    func mapSnapshot(_ maker: TransitionMaker.SnapshotType?) -> HeroSnapshotType? {
        guard let maker else { return nil }
        switch maker {
            case .optimized: return .optimized
            case .normal: return .normal
            case .layerRender: return .layerRender
            case .noSnapshot: return .noSnapshot
        }
    }
}
