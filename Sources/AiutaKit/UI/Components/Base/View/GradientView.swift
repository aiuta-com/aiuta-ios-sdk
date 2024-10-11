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

@_spi(Aiuta) public final class GradientView: UIView {
    public struct ColorStop {
        public let color: UIColor
        public let stop: CGFloat

        public init(_ color: UIColor, _ stop: CGFloat) {
            self.color = color
            self.stop = stop
        }
        
        public init(_ color: Int, _ stop: CGFloat) {
            self.color = color.uiColor
            self.stop = stop
        }
    }

    public var startColor: UIColor = .red
    public var endColor: UIColor = .blue

    public var colors: [CGColor]?
    public var colorStops: [ColorStop]?

    public var startPoint: CGPoint = .init(x: 0.5, y: 0)
    public var endPoint: CGPoint = .init(x: 0.5, y: 1)

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override public func layoutSubviews() {
        if let colorStops {
            gradientLayer.colors = colorStops.map { $0.color.cgColor }
            gradientLayer.locations = colorStops.map { NSNumber(floatLiteral: $0.stop) }
        } else {
            gradientLayer.colors = colors ?? [startColor.cgColor, endColor.cgColor]
        }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        updateShapeWithRoundedCorners()
    }
}
