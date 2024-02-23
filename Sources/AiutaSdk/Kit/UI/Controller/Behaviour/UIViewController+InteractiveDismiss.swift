//
//  Created by nGrey on 05.07.2023.
//

import Hero
import UIKit

extension UIViewController {
    func enableInteractiveDismiss(withTarget target: ContentBase? = nil,
                                  inverseGesture inversed: Bool = false,
                                  edgeWidthFraction border: CGFloat = 1,
                                  progressMultyplier: CGFloat = 0.6,
                                  progressToFinish: CGFloat = 0.35) {
        (target ?? viewAsUI)?.gestures.onPan(.horizontal, with: self) { [unowned self] pan in
            let hero = Hero.shared
            let sign: CGFloat = inversed ? -1 : 1
            let translation = pan.translation(in: nil)
            let velocity = sign * pan.velocity(in: nil).x
            let progress = sign * progressMultyplier * translation.x / view.bounds.width
            switch pan.state {
                case .began:
                    willTransitInteractive = false
                    hasTransitionUpdates = false
                    guard !isShowingBulletin, pan.location(in: nil).x < view.bounds.width * border else {
                        pan.cancel()
                        return
                    }
                    isDeparting = true
                    whenDismiss(interactive: true)
                    dismiss()
                    willTransitInteractive = true
                case .changed:
                    guard willTransitInteractive else { return }
                    hasTransitionUpdates = true
                    hero.update(progress)
                case .ended:
                    guard willTransitInteractive else { return }
                    willTransitInteractive = false
                    if progress + velocity / view.bounds.width > progressToFinish {
                        if hasTransitionUpdates {
                            delay(.moment) { hero.finish() }
                            whenDettached()
                        }
                    } else {
                        hero.cancel()
                        isDeparting = false
                        whenCancelDismiss()
                    }
                default:
                    guard willTransitInteractive else { return }
                    willTransitInteractive = false
                    hero.cancel()
                    isDeparting = false
                    whenCancelDismiss()
            }
        }
    }
}
