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

import UIKit

@_spi(Aiuta) open class Blur: Content<CustomIntensityVisualEffectView> {
    public enum SoftEdge {
        case top, bottom
        case topAndBottom
    }

    private let gradientMaskLayer = CAGradientLayer()

    public var style: UIBlurEffect.Style = .regular {
        didSet {
            view.theEffect = UIBlurEffect(style: style)
            view.setNeedsDisplay()
        }
    }

    @available(iOS 26, *)
    public var glass: UIGlassEffect.Style? {
        get { nil }
        set {
            guard let newValue else { return }
            view.theEffect = UIGlassEffect(style: newValue)
            view.setNeedsDisplay()
        }
    }

    public var color: UIColor = .clear {
        didSet { view.subviews.forEach { $0.backgroundColor = color }}
    }

    public var tint: UIColor = .clear {
        didSet { color = tint.withAlphaComponent(0.65) }
    }

    public var backgroundColor: UIColor {
        get { view.backgroundColor ?? .clear }
        set { view.backgroundColor = newValue }
    }

    public var intensity: CGFloat = 1 {
        didSet { view.customIntensity = intensity }
    }

    public var softness: CGFloat = 0.03 {
        didSet { updateSoftEdge() }
    }

    public var softOffset: CGFloat = 0 {
        didSet { updateSoftEdge() }
    }

    public var softEdge: SoftEdge? = .none {
        didSet { updateSoftEdge() }
    }

    public convenience init(_ builder: (_ it: Blur, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    override func updateLayoutInternal() {
        view.mask?.frame = view.bounds
        gradientMaskLayer.frame = view.bounds
    }

    private func updateSoftEdge() {
        guard let softEdge else {
            gradientMaskLayer.removeFromSuperlayer()
            view.mask = nil
            return
        }

        let softness = clamp(softness, min: 0.01, max: 0.49)
        let offset = clamp(softOffset, min: 0, max: softness)
        let startOffset = NSNumber(floatLiteral: offset)
        let startSofness = NSNumber(floatLiteral: softness)
        let endSoftness = NSNumber(floatLiteral: 1 - softness)
        let endOffset = NSNumber(floatLiteral: 1 - offset)

        switch softEdge {
            case .top:
                gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
                gradientMaskLayer.locations = [0, startOffset, startSofness, 1]
            case .bottom:
                gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
                gradientMaskLayer.locations = [0, endSoftness, endOffset, 1]
            case .topAndBottom:
                gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
                gradientMaskLayer.locations = [0, startOffset, startSofness, endSoftness, endOffset, 1]
        }

        if gradientMaskLayer.superlayer == nil {
            let gradientMaskView = UIView()
            gradientMaskView.layer.addSublayer(gradientMaskLayer)
            view.mask = gradientMaskView
        }
    }
}

@_spi(Aiuta) public final class CustomIntensityVisualEffectView: UIVisualEffectView {
    fileprivate var theEffect: UIVisualEffect = UIBlurEffect(style: .regular)
    fileprivate var customIntensity: CGFloat = 1 {
        didSet { animator?.fractionComplete = customIntensity }
    }

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
        if #available(iOS 26, *) {
            if theEffect is UIGlassEffect, effect != theEffect {
                effect = theEffect
                return
            }
        }

        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
