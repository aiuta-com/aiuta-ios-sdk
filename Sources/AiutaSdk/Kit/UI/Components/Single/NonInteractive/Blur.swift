//
//  Created by nGrey on 16.05.2023.
//

import UIKit

class Blur: Content<CustomIntensityVisualEffectView> {
    var style: UIBlurEffect.Style = .regular {
        didSet {
            view.theEffect = UIBlurEffect(style: style)
            view.setNeedsDisplay()
        }
    }

    var color: UIColor = .clear {
        didSet { view.subviews.forEach { $0.backgroundColor = color }}
    }
    
    var tint: UIColor = .clear {
        didSet { color = tint.withAlphaComponent(0.65) }
    }

    var intensity: CGFloat = 1 {
        didSet { view.customIntensity = intensity }
    }

    convenience init(_ builder: (_ it: Blur, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

final class CustomIntensityVisualEffectView: UIVisualEffectView {
    fileprivate var theEffect: UIVisualEffect = UIBlurEffect(style: .regular)
    fileprivate var customIntensity: CGFloat = 1
    private var animator: UIViewPropertyAnimator?

    init() {
        super.init(effect: nil)
    }

    required init?(coder aDecoder: NSCoder) { nil }

    deinit {
        animator?.stopAnimation(true)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
