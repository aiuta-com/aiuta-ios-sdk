//
//  Created by nGrey on 26.05.2023.
//

import UIKit

public func haptic(impact style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
}

public func haptic(notification type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
}

public func haptic() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
}
