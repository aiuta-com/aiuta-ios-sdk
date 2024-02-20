//
//  Created by nGrey on 18.07.2023.
//

import UIKit

public final class LoadingBulletin: PlainBulletin {
    let spinner = Spinner { it, ds in
        it.view.color = ds.color.item
    }

    private var hasSpinner = true

    override public func setup() {
        behaviour = .fullscreen
        hasStroke = false

        spinner.view.opacity = 0
        if hasSpinner {
            spinner.animations.opacityTo(1, delay: .oneSecond)
        }
    }

    public func showSpinner(delay: AsyncDelayTime = .instant) {
        spinner.animations.opacityTo(1, delay: delay)
    }

    public func hideSpinner(duration: AsyncDelayTime) {
        switch duration {
            case .instant: spinner.view.opacity = 0
            default: spinner.animations.opacityTo(0, time: duration)
        }
    }

    override public func updateLayout() {
        layout.make { make in
            make.width = layout.screen.width
            make.height = layout.screen.height - layout.safe.insets.top - 48
        }

        spinner.layout.make { make in
            make.centerX = 0
            make.centerY = -48
        }
    }

    public convenience init(empty: Bool, isDismissable: Bool = false) {
        self.init()
        hasSpinner = !empty
        isDismissableByPan = isDismissable
    }
}
