//
//  Created by nGrey on 08.12.2023.
//

import UIKit

final class Snackbar<Body: Plane>: Plane {
    let bar = Body()

    @scrollable
    var placeholder = ScrollSpacer()

    var isVisible = false {
        didSet {
            guard oldValue != isVisible else { return }
            view.isUserInteractionEnabled = isVisible
            placeholder.isVisible = isVisible
            animations.updateLayout()
        }
    }

    override func setupInternal() {
        view.isUserInteractionEnabled = isVisible
    }
    
    var bottomInset: CGFloat = 0

    override func updateLayoutInternal() {
        placeholder.height = bar.layout.height + 8
        
        layout.make { make in
            make.height = bar.layout.height
            make.width = min(600, layout.boundary.width - 16)
            make.centerX = 0
            make.bottom = isVisible ? (bottomInset > 0 ? bottomInset : layout.safe.insets.bottom) + 8 : -make.height
        }

        bar.layout.make { make in
            make.size = layout.size
            make.top = 0
        }
    }

    final class ScrollSpacer: Plane {
        var isVisible = false {
            didSet {
                guard oldValue != isVisible else { return }
                animations.animate { [self] in
                    parentScroll?.update()
                }
            }
        }

        var height: CGFloat = 0 {
            didSet {
                guard oldValue != height else { return }
                parentScroll?.update()
            }
        }

        override func updateLayoutInternal() {
            layout.make { make in
                make.height = isVisible ? height : 0
            }
        }

        var parentScroll: VScroll? {
            firstParentOfType()
        }
    }
}
