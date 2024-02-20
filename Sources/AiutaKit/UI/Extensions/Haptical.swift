//
//  Created by nGrey on 26.05.2023.
//

import Haptica

public func haptic(impact style: HapticFeedbackStyle) {
    Haptic.impact(style).generate()
}

public func haptic(notification type: HapticFeedbackType) {
    Haptic.notification(type).generate()
}

public func haptic() {
    Haptic.selection.generate()
}
