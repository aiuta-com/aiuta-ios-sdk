//
//  Created by nGrey on 21.06.2023.
//

import Foundation
import UIKit

struct SizeFractions: Equatable {
    enum Width: Equatable {
        case constant(CGFloat)
        case fraction(CGFloat)
        case minWidth(CGFloat)
        case maxWidth(CGFloat)
        case fractionMaxWidth(CGFloat, CGFloat)
    }

    enum Height: Equatable {
        case constant(CGFloat)
        case widthMultiplyer(CGFloat)
    }

    let width: Width
    let height: Height

    init(width: Width, height: Height) {
        self.width = width
        self.height = height
    }
}

extension SizeFractions {
    func calculateItemSize(availableSize: CGSize, withSpacer spacer: CGSize = .zero) -> CGSize {
        guard availableSize.width > 0 else { return .zero }

        var w: CGFloat = calculateWidth(availableWidth: availableSize.width)

        let itemsInRow = Int(floor(availableSize.width / w))
        let spacersInRow = max(itemsInRow - 1, 0)
        if spacersInRow > 0 {
            let compactWidth = availableSize.width - spacer.width * CGFloat(spacersInRow)
            w = compactWidth / (availableSize.width / w)
        }

        let h: CGFloat = calculateHeight(itemWidth: w)

        return CGSize(width: w, height: h)
    }
}

private extension SizeFractions {
    func calculateWidth(availableWidth: CGFloat) -> CGFloat {
        guard availableWidth > 0 else { return 0 }
        var w: CGFloat
        switch width {
            case let .constant(width):
                w = min(width, availableWidth)
            case let .fraction(multiplyer):
                w = calculateFractionWidth(multiplyer, of: availableWidth)
            case let .minWidth(minWidth):
                w = calculateMinWidth(minWidth, of: availableWidth)
            case let .maxWidth(maxWidth):
                w = calculateMaxWidth(maxWidth, of: availableWidth)
            case let .fractionMaxWidth(multiplyer, maxWidth):
                w = calculateFractionWidth(multiplyer, of: availableWidth)
                if w > maxWidth { w = calculateMaxWidth(maxWidth, of: availableWidth) }
        }
        return w
    }

    private func calculateFractionWidth(_ multiplyer: CGFloat, of availableWidth: CGFloat) -> CGFloat {
        guard multiplyer > 0 else { return 0 }
        return min(availableWidth * multiplyer, availableWidth)
    }

    private func calculateMinWidth(_ maxWidth: CGFloat, of availableWidth: CGFloat) -> CGFloat {
        let count = max(1, floor(availableWidth / maxWidth))
        return availableWidth * (1.0 / count)
    }

    private func calculateMaxWidth(_ maxWidth: CGFloat, of availableWidth: CGFloat) -> CGFloat {
        let count = max(1, ceil(availableWidth / maxWidth))
        return availableWidth * (1.0 / count)
    }
}

private extension SizeFractions {
    private func calculateHeight(itemWidth: CGFloat) -> CGFloat {
        let h: CGFloat
        switch height {
            case let .constant(height):
                h = height
            case let .widthMultiplyer(multiplyer):
                h = itemWidth * multiplyer
        }
        return h
    }
}
