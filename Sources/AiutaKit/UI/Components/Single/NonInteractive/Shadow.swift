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

@_spi(Aiuta) open class Shadow: Plane {
    public let stroke = Stroke()

    public var color: UIColor {
        get { stroke.color }
        set { stroke.color = newValue }
    }
    
    public var isAutoSize = false

    public var cornerRadius: CGFloat {
        get { stroke.cornerRadius }
        set { stroke.cornerRadius = newValue }
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
        if isAutoSize {
            layout.make { make in
                make.size = layout.boundary.size
            }
        }
        stroke.layout.make { make in
            make.size = layout.size
            make.radius = cornerRadius
        }
    }

    public convenience init(_ builder: (_ it: Shadow, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

@_spi(Aiuta) open class LoneShadow: Plane {
    let shadow = Stroke { it, _ in
        it.color = .clear
    }

    let droplet = Stroke { it, _ in
        it.color = .black
    }

    public var color: UIColor {
        get { .black }
        set { shadow.view.layer.shadowColor = newValue.cgColor }
    }

    public var opacity: Float {
        get { shadow.view.layer.shadowOpacity }
        set { shadow.view.layer.shadowOpacity = newValue }
    }

    public var radius: CGFloat {
        get { shadow.view.layer.shadowRadius }
        set { shadow.view.layer.shadowRadius = newValue }
    }

    public var offset: CGSize {
        get { shadow.view.layer.shadowOffset }
        set { shadow.view.layer.shadowOffset = newValue }
    }

    public var cornerRadius: CGFloat = 0

    override func setupInternal() {
        shadow.addContent(droplet)
    }

    override func updateLayoutInternal() {
        let bounds = view.bounds
        shadow.view.frame = bounds
        droplet.view.frame = bounds
        droplet.view.cornerRadius = cornerRadius
        var isContinuous = false
        if #available(iOS 13.0, *) {
            isContinuous = bounds.width != bounds.height
            droplet.view.cornerCurve = isContinuous ? .continuous : .circular
            if isContinuous { droplet.view.cornerRadius = cornerRadius + 1 }
        }
        let inset = -(max(abs(offset.width), abs(offset.height)) + radius) - radius * 2
        let maskFrame = bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        let p = CGMutablePath()
        p.addRect(maskFrame)
        if isContinuous {
            p.addPath(UIBezierPath(continuousRoundedRect: bounds, cornerRadius: cornerRadius).cgPath)
        } else {
            p.addPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath)
        }

        let s = CAShapeLayer()
        s.path = p
        s.fillRule = .evenOdd
        shadow.view.layer.mask = s
    }

    public convenience init(_ builder: (_ it: LoneShadow, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
