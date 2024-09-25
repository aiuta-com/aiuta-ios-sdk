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

@_spi(Aiuta) public extension UIViewController {
    func enableInteractiveDismiss(withTarget target: ContentBase? = nil,
                                  inverseGesture inversed: Bool = false,
                                  edgeWidthFraction border: CGFloat = 1,
                                  progressMultyplier: CGFloat = 0.6,
                                  progressToFinish: CGFloat = 0.35) {
        (target ?? viewAsUI)?.gestures.onPan(.horizontal, with: self) { [unowned self] pan in
            @Injected var heroic: Heroic
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
                    // if velocity >= 900 { return }
                    willTransitInteractive = true
                case .changed:
                    guard willTransitInteractive else { return }
                    hasTransitionUpdates = true
                    heroic.update(percent: progress)
                case .ended:
                    guard willTransitInteractive else { return }
                    willTransitInteractive = false
                    if progress + velocity / view.bounds.width > progressToFinish {
                        if hasTransitionUpdates {
                            delay(.moment) { heroic.finish(animate: true) }
                        }
                    } else {
                        heroic.cancel(animate: true)
                        isDeparting = false
                    }
                default:
                    guard willTransitInteractive else { return }
                    willTransitInteractive = false
                    heroic.cancel(animate: true)
                    isDeparting = false
            }
        }
    }
}
