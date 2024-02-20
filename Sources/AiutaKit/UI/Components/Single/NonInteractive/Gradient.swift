//
//  Created by nGrey on 26.05.2023.
//

import UIKit

open class Gradient: Content<GradientView> {
    public enum Direction {
        case vertical
        case horizontal
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

    public var direction: Direction = .vertical {
        didSet {
            switch direction {
                case .vertical:
                    view.startPoint = .init(x: 0.5, y: 0)
                    view.endPoint = .init(x: 0.5, y: 1)
                case .horizontal:
                    view.startPoint = .init(x: 0, y: 0.5)
                    view.endPoint = .init(x: 1, y: 0.5)
            }
        }
    }

    public convenience init(_ builder: (_ it: Gradient, _ ds: DesignSystem) -> Void) {
        self.init()
        view.isUserInteractionEnabled = false
        builder(self, ds)
    }
}
