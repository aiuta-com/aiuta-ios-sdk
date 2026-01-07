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

@_spi(Aiuta) open class Gradient: Content<GradientView> {
    public enum Direction {
        public enum Tilt {
            case ascending, descending
        }

        case vertical
        case horizontal
        case tilt(Tilt)
        case diagonal(Tilt)
        case custom(CGPoint, CGPoint)
    }

    public var cornerRadius: CGFloat {
        get { view.cornerRadius }
        set { view.cornerRadius = newValue }
    }

    public var starColor: UIColor {
        get { view.startColor }
        set { view.startColor = newValue }
    }

    public var endColor: UIColor {
        get { view.endColor }
        set { view.endColor = newValue }
    }

    public var colorStops: [GradientView.ColorStop]? {
        get { view.colorStops }
        set { view.colorStops = newValue }
    }

    public var colors: [UIColor]? {
        get { view.colors?.map { UIColor(cgColor: $0) } }
        set { view.colors = newValue?.map { $0.cgColor } }
    }

    public var direction: Direction = .vertical {
        didSet {
            switch direction {
                case .vertical:
                    view.startPoint = .init(x: 0.5, y: 0)
                    view.endPoint = .init(x: 0.5, y: 1)
                case .horizontal:
                    view.startPoint = .init(x: 0, y: 0.5)
                    view.endPoint = .init(x: 1, y: 0.5)
                case .tilt(.ascending):
                    view.startPoint = .init(x: 0, y: 0.55)
                    view.endPoint = .init(x: 1, y: 0.45)
                case .tilt(.descending):
                    view.startPoint = .init(x: 0, y: 0.45)
                    view.endPoint = .init(x: 1, y: 0.55)
                case .diagonal(.ascending):
                    view.startPoint = .init(x: 0, y: 0.7)
                    view.endPoint = .init(x: 1, y: 0.3)
                case .diagonal(.descending):
                    view.startPoint = .init(x: 0, y: 0.3)
                    view.endPoint = .init(x: 1, y: 0.7)
                case let .custom(start, stop):
                    view.startPoint = start
                    view.endPoint = stop
            }
        }
    }

    public convenience init(_ builder: (_ it: Gradient, _ ds: DesignSystem) -> Void) {
        self.init()
        view.isUserInteractionEnabled = false
        builder(self, ds)
    }
}
