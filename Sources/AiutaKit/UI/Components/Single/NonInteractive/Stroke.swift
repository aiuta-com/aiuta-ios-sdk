//
// Created by nGrey on 25.03.2023.
//

import UIKit

open class Stroke: Plane {
    public var color: UIColor {
        get { view.backgroundColor ?? .clear }
        set { view.backgroundColor = newValue }
    }

    public var cornerRadius: CGFloat {
        get { view.cornerRadius }
        set { view.cornerRadius = newValue }
    }

    private var gradientLayer: CAGradientLayer?

    public func gradient(_ closure: (_ make: CAGradientLayer) -> Void) {
        let gradient = gradientLayer ?? CAGradientLayer()
        gradientLayer = gradient
        view.layer.addSublayer(gradient)
        closure(gradient)
        if gradient.superlayer.isNil {
            gradientLayer = nil
        }
    }

    override func sizeToFit() {
        gradientLayer?.frame = view.bounds
    }

    public convenience init(_ builder: (_ it: Stroke, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

open class Shadow: Plane {
    public let stroke = Stroke()

    public var color: UIColor {
        get { stroke.color }
        set { stroke.color = newValue }
    }

    public var cornerRadius: CGFloat {
        get { stroke.cornerRadius }
        set {
            stroke.cornerRadius = newValue
            view.cornerRadius = newValue
        }
    }

    public var shadowColor: UIColor {
        get { .black }
        set { view.layer.shadowColor = newValue.cgColor }
    }

    public var shadowOffset: CGSize {
        get { view.layer.shadowOffset }
        set { view.layer.shadowOffset = newValue }
    }

    public var shadowOpacity: Float {
        get { view.layer.shadowOpacity }
        set { view.layer.shadowOpacity = newValue }
    }

    public var shadowRadius: CGFloat {
        get { view.layer.shadowRadius }
        set { view.layer.shadowRadius = newValue }
    }

    override func setupInternal() {
        view.masksToBounds = false
    }

    override func updateLayoutInternal() {
        stroke.layout.make { make in
            make.size = layout.size
        }
    }

    public convenience init(_ builder: (_ it: Shadow, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
