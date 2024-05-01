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

@_spi(Aiuta) import AiutaKit
import Resolver
import UIKit

final class AiutaTryOnResultView: Scroll {
    let willShowContinuation = Signal<Void>()
    let didNavigateToItem = Signal<(Aiuta.GeneratedImage, Aiuta.SkuInfo?, AnalyticEvent.ResultsScreen.NavigationType)>()

    @Injected private var heroic: Heroic

    @scrollable
    var results = AiutaTryOnResultCell.ScrollRecycler()

    @scrollable
    var moreHeader = AiutaTryOnMoreHeaderView()

    @scrollable
    var moreToTryOn = AiutaTryOnMoreSkuCell.ScrollRecycler()

    let navigation = AiutaTryOnResultNavigationView()

    let footer = AiutaTryOnResultFooterView()

    private var oldDataFocus: Aiuta.SessionResult?
    var data: DataProvider<Aiuta.SessionResult>? {
        willSet {
            oldDataFocus = currentData
        }
        didSet {
            if let data {
                results.data = FilterDataProvider(input: data, filter: { switch $0 {
                    case .input: return false
                    default: return true
                } })
            } else {
                results.data = nil
            }
            navigation.items.data = data
            if let oldDataFocus, let index = results.data?.items.firstIndex(of: oldDataFocus) {
                scrollView.scroll(to: offset(fromIndex: index), animated: false)
            }
        }
    }

    private var startIndex: Int = 0

    override func setup() {
        scrollView.appearance.make { make in
            make.decelerationRate = .fast
        }

        scrollView.willBeginDragging.subscribe(with: self) { [unowned self] in
            startIndex = index(fromOffest: scrollView.contentOffset.y)
        }

        scrollView.didScroll.subscribe(with: self) { [unowned self] _ in
            isContinuationMode = scrollView.contentOffset.y + scrollView.contentInset.top - moreHeader.layout.top > -availableHeight / 2
            currentItemIndex = clamp(index(fromOffest: scrollView.contentOffset.y), min: 0, max: maxItemIndex)
        }

        scrollView.didEndDragging.subscribe(with: self) { [unowned self] velocity, targetContentOffset in
            var targetIndex = startIndex
            if velocity.y > 0 { targetIndex += 1 }
            if velocity.y < 0 { targetIndex -= 1 }

            guard targetIndex <= maxItemIndex + 1 else {
                let scrollTarget = index(fromOffest: targetContentOffset.pointee.y)
                if scrollTarget <= maxItemIndex {
                    scrollView.fastDeceleration = true
                    targetContentOffset.pointee.y = offset(fromIndex: scrollTarget)
                    return
                }
                scrollView.fastDeceleration = false
                return
            }

            scrollView.fastDeceleration = true
            targetContentOffset.pointee.y = offset(fromIndex: targetIndex)
            if targetIndex == maxItemIndex + 1 {
                targetContentOffset.pointee.y += 40
            }
        }

        scrollView.didFinishScroll.subscribe(with: self) { [unowned self] in
            guard case let .output(genImage, skuInfo) = currentData else { return }
            didNavigateToItem.fire((genImage, skuInfo, .swipe))
        }

        navigation.items.onRegisterItem.subscribe(with: self) { [unowned self] item in
            item.onTouchUpInside.subscribe(with: self) { [unowned self, weak item] in
                guard let data = item?.data, let index = results.data?.items.firstIndex(of: data) else { return }
                scrollView.scroll(to: offset(fromIndex: index), animated: true)
                guard case let .output(genImage, skuInfo) = results.data?.items[safe: index] else { return }
                didNavigateToItem.fire((genImage, skuInfo, .thumbnail))
            }
        }

        navigation.items.onUpdateItem.subscribe(with: self) { [unowned self] item in
            item.isSelected = item.data == currentData
        }

        results.onUpdateItem.subscribe(with: self) { [unowned self] cell in
            cell.skuGallery.pages.forEach { skuCell in
                guard cell.index.isLast else {
                    skuCell.contentView.swipeForMore.shouldBeVisible = false
                    return
                }
                skuCell.contentView.swipeForMore.shouldBeVisible = !isContinuationMode && moreHeader.isVisible
            }
        }

        heroic.willStartTransition.subscribe(with: self) { [unowned self] in
            hasNavigation = false
        }

        heroic.didCompleteTransition.subscribe(with: self) { [unowned self] in
            hasNavigation = true
        }
    }

    func index(fromOffest offset: CGFloat) -> Int {
        Int(round((offset + scrollView.contentInset.top) / contenHeight))
    }

    func offset(fromIndex index: Int) -> CGFloat {
        CGFloat(index) * contenHeight - scrollView.contentInset.top - scrollOffset
    }

    private(set) var currentItemIndex: Int = -1 {
        didSet {
            guard oldValue != currentItemIndex else { return }
            navigation.items.updateItems()
            if let currentData, let navIindex = navigation.items.data?.items.firstIndex(of: currentData) {
                let offset = CGFloat(navIindex * 106)
                navigation.scrollView.scroll(to: offset, animated: true)
            }
        }
    }

    private var currentData: Aiuta.SessionResult? {
        results.data?.items[safe: currentItemIndex]
    }

    var isContinuationMode = false {
        didSet {
            guard data.isSome else { return }
            guard oldValue != isContinuationMode else { return }
            if isContinuationMode {
                navigation.appearance.freeze()
                willShowContinuation.fire()
            } else {
                navigation.appearance.unfreeze()
            }
            moreHeader.pin.animations.visibleTo(isContinuationMode)
            if let tryOnView = parent as? AiutaTryOnView {
                tryOnView.hasSkuBar = !isContinuationMode
            } else {
                animations.updateLayout()
            }
            results.updateItems()
        }
    }

    var maxItemIndex: Int {
        (results.data?.items.count ?? 1) - 1
    }

    var topInset: CGFloat = 0 {
        didSet {
            guard oldValue != topInset else { return }
            updateLayout()
        }
    }

    var availableHeight: CGFloat {
        layout.height - topInset - footer.layout.height
    }

    var scrollOffset: CGFloat {
        (availableHeight - contenHeight) / 2 - 15
    }

    var contenHeight: CGFloat {
        availableHeight - 30
    }

    var hasNavigation = true {
        didSet {
            guard oldValue != hasNavigation else { return }
            if hasNavigation {
                animations.updateLayout()
            }
        }
    }

    override func updateLayout() {
        scrollView.contentInset = .init(top: topInset + 10, bottom: footer.layout.height + 10)
        results.contentFraction = .init(width: .fraction(1), height: .constant(contenHeight - 8))

        navigation.layout.make { make in
            make.width = 54
            make.left = !hasNavigation || isContinuationMode ? -make.width : 16
            make.top = topInset
            make.bottom = footer.layout.height
        }

        footer.layout.make { make in
            make.bottom = !hasNavigation || isContinuationMode ? -make.height : 0
        }
    }
}
