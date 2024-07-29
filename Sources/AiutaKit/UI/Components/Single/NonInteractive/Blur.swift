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
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
}
