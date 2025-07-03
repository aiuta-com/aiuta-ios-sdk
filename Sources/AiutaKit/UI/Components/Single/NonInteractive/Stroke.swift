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

@_spi(Aiuta) open class Stroke: Plane {
    public var color: UIColor {
        get { view.backgroundColor ?? .clear }
        set { view.backgroundColor = newValue }
    }

    public var cornerRadius: CGFloat {
        get { view.cornerRadius }
        set { view.cornerRadius = newValue }
    }

    public var fixedHeight: CGFloat?
    public var fixedWidth: CGFloat?

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

    override func updateLayoutInternal() {
        if let fixedHeight {
            layout.make { make in
                make.height = fixedHeight
            }
        }

        if let fixedWidth {
            layout.make { make in
                make.width = fixedWidth
            }
        }
    }

    public convenience init(_ builder: (_ it: Stroke, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
