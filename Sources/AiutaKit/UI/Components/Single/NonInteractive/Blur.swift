//
//  Created by nGrey on 16.05.2023.
//

import UIKit

open class Blur: Content<CustomIntensityVisualEffectView> {
    public var style: UIBlurEffect.Style = .regular {
        didSet {
            view.theEffect = UIBlurEffect(style: style)
            view.setNeedsDisplay()
        }
    }

    public var color: UIColor = .clear {
        didSet { view.subviews.forEach { $0.backgroundColor = color }}
    }
    
    public var tint: UIColor = .clear {
        didSet { color = tint.withAlphaComponent(0.65) }
    }

    public var intensity: CGFloat = 1 {
        didSet { view.customIntensity = intensity }
    }

    public convenience init(_ builder: (_ it: Blur, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

public final class CustomIntensityVisualEffectView: UIVisualEffectView {
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

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
