//
//  Created by nGrey on 19.04.2023.
//

import UIKit

open class CardsView<CardCellType, CardCellDataType>: Content<PlainView> where CardCellType: CardCell<CardCellDataType> {
    public weak var pageIndicator: PageIndicator? {
        didSet {
            pageIndicator?.count = data?.count ?? 0
            pageIndicator?.index = currentIndex
        }
    }

    public var data: [CardCellDataType]? {
        didSet {
            guard let data else { return }
            let count = data.count
            var i = 0
            cards.forEach { removeContent($0) }
            cards = data.map({ dataItem in
                let card = CardCellType()
                card.update(dataItem, at: ItemIndex(i, of: count))
                card.gestures.onPan(.horizontal, with: self) { [unowned self] pan in
                    switch pan.state {
                        case .changed, .ended: panBeganOrEnded(pan: pan)
                        default: break
                    }
                }
                addContent(card)
                card.sendToBack()
                i += 1
                return card
            })
            updateLayout()
            pageIndicator?.count = data.count
        }
    }

    public var current: CardCellDataType? {
        data?[currentIndex]
    }

    private var cards = [CardCellType]()

    private var currentIndex: Int = 0 {
        didSet { pageIndicator?.index = currentIndex }
    }

    private let panToSwipe: CGFloat = 30

    override open func updateLayout() {
        let panMax: CGFloat = layout.width * 0.75
        let panProgress: CGFloat = clamp(panOffset, min: -panMax, max: panMax) / panMax
        let nextPanProgress: CGFloat = panProgress < 0 ? -panProgress : 0
        let prevPanProgress: CGFloat = panProgress > 0 ? panProgress : 0

        cards.indexed.forEach { index, card in
            let relativeIndex = index - currentIndex

            card.layout.make { make in
                make.height = layout.height - 8
                make.width = layout.width - 32
                switch relativeIndex {
                    case Int.min ... -1:
                        make.bottom = 8
                        make.scale = 1
                        make.left = -make.width
                        if relativeIndex == -1, currentIndex > 0 {
                            make.left += max(0, panOffset)
                        }
                    case 0:
                        make.scale = 1
                        make.bottom = 8
                        make.centerX = 0
                        if currentIndex == 0 {
                            make.left += panOffset < 0 ? panOffset : panOffset / 3
                        } else {
                            if currentIndex == cards.count - 1 {
                                make.left += min(0, panOffset > 0 ? panOffset : panOffset / 3)
                            } else {
                                make.left += min(0, panOffset)
                            }
                            if panOffset > 0 {
                                make.width = layout.width - 64 + 32 * (1 - prevPanProgress)
                                let scale = make.width / (layout.width - 32)
                                make.scale = scale
                                make.height *= scale
                                make.centerX = 0
                                make.bottom = 8 * (1 - prevPanProgress)
                            }
                        }
                    case 1:
                        make.width = layout.width - 64 + 32 * nextPanProgress
                        let scale = make.width / (layout.width - 32)
                        make.scale = scale
                        make.height *= scale
                        make.centerX = 0
                        make.bottom = 8 * nextPanProgress
                    default:
                        make.width = layout.width - 64
                        let scale = make.width / (layout.width - 32)
                        make.scale = scale
                        make.height *= scale
                        make.bottom = 0
                        make.centerX = 0
                }
            }

            card.appearance.make { make in
                let fastProgress = CGFloat(min(1, nextPanProgress * 2))
                let slowProgress = CGFloat(prevPanProgress / 2)
                switch relativeIndex {
                    case Int.min ... 0:
                        make.opacity = make.maxOpacity
                        make.cornerRadius = 36
                        if relativeIndex == 0, currentIndex > 0, panOffset > 0 {
                            make.opacity = make.maxOpacity - slowProgress * make.maxOpacity / 2
                            make.cornerRadius = 36 - 8 * prevPanProgress
                        }
                    case 1:
                        make.opacity = (1 + fastProgress) * make.maxOpacity / 2
                        make.cornerRadius = 24 + 8 * nextPanProgress
                    case 2:
                        make.opacity = fastProgress * make.maxOpacity / 2
                        make.cornerRadius = 24
                    default:
                        make.opacity = 0
                }
            }
        }
    }

    private var panOffset: CGFloat = 0 {
        didSet { updateLayout() }
    }

    func panBeganOrEnded(pan: UIPanGestureRecognizer) {
        switch pan.state {
            case .changed:
                panOffset = pan.translation(in: nil).x
            case .ended:
                if panOffset < -panToSwipe, currentIndex < cards.count - 1 {
                    currentIndex += 1
                }
                if panOffset > panToSwipe, currentIndex > 0 {
                    currentIndex -= 1
                }
                animations.animate(dampingRatio: 0.7) { [self] in
                    panOffset = 0
                }
            default: break
        }
    }
}
