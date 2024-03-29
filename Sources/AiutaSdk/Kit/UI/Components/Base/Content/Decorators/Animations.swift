//
// Created by nGrey on 28.02.2023.
//

import UIKit

final class Animations {
    private let view: UIView

    init(target: UIView) {
        view = target
    }

    func animate(delay delayTime: AsyncDelayTime,
                        time duration: AsyncDelayTime = .quarterOfSecond,
                        changes: @escaping AsyncCallback,
                        complete completion: AsyncCallback? = nil) {
        if delayTime == .instant { animate(time: duration, changes: changes, complete: completion) }
        else { delay(delayTime) { self.animate(time: duration, changes: changes, complete: completion) } }
    }

    func animate(delay delayTime: AsyncDelayTime,
                        time duration: AsyncDelayTime = .quarterOfSecond,
                        changes: @escaping AsyncCallback) {
        if delayTime == .instant { animate(time: duration, changes: changes) }
        else { delay(delayTime) { self.animate(time: duration, changes: changes) } }
    }

    func animate(time duration: AsyncDelayTime = .quarterOfSecond, curve: UIView.AnimationOptions = .curveEaseInOut, changes: @escaping AsyncCallback) {
        animate(time: duration, changes: changes, complete: nil)
    }

    func animate(time duration: AsyncDelayTime = .quarterOfSecond, curve: UIView.AnimationOptions = .curveEaseInOut, changes: @escaping AsyncCallback, complete completion: AsyncCallback? = nil) {
        if duration == .instant {
            changes()
            completion?()
            return
        }
        UIView.animate(withDuration: duration.seconds, delay: 0, options: [curve, .allowUserInteraction], animations: changes) { _ in completion?() }
    }

    func animate(dampingRatio ratio: CGFloat, time duration: TimeInterval? = nil, delay: AsyncDelayTime? = nil, changes: @escaping AsyncCallback, complete completion: AsyncCallback? = nil) {
        let animator = UIViewPropertyAnimator(duration: duration ?? 1.3 - TimeInterval(ratio), dampingRatio: ratio, animations: changes)
        animator.addCompletion { _ in completion?() }
        if let delay {
            animator.startAnimation(afterDelay: delay.seconds)
        } else {
            animator.startAnimation()
        }
    }

    func transition(_ options: UIView.AnimationOptions, duration: AsyncDelayTime = .oneSecond, complete completion: AsyncCallback? = nil) {
        view.isUserInteractionEnabled = false
        UIView.transition(with: view, duration: duration.seconds, options: [options, .allowUserInteraction], animations: nil) { [weak view] _ in
            view?.isUserInteractionEnabled = true
            completion?()
        }
    }

    func pause() {
        view.layer.pauseAnimations()
    }

    func resume() {
        view.layer.resumeAnimations()
    }

    func visibleTo(_ value: Bool, showTime: AsyncDelayTime = .quarterOfSecond, hideTime: AsyncDelayTime = .quarterOfSecond, complete: AsyncCallback? = nil) {
        guard view.isVisible != value else {
            complete?()
            return
        }
        if value { view.isHidden = false }
        opacityTo(value ? view.maxOpacity : view.minOpacity, time: value ? showTime : hideTime) { [weak view] in
            if let view, !view.isVisible {
                view.isHidden = true
                complete?()
            }
        }
    }

    func opacityTo(_ value: CGFloat, time duration: AsyncDelayTime = .quarterOfSecond, delay: AsyncDelayTime = .instant, complete: AsyncCallback? = nil) {
        guard view.opacity != value else {
            complete?()
            return
        }
        animate(delay: delay, time: duration, changes: { [weak view] in
            view?.opacity = value
        }, complete: complete)
    }

    func shake() {
        view.shake()
    }

    func rotate(duration: Double) {
        view.rotate(duration: duration)
    }

    func updateLayout(afterDelay delayTime: AsyncDelayTime = .instant, withDuration duration: AsyncDelayTime = .quarterOfSecond, onComplete completion: AsyncCallback? = nil) {
        animate(delay: delayTime, time: duration, changes: { [view] in
            view.layoutSubviews()
        }, complete: completion)
    }
}
