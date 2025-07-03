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

@_spi(Aiuta) open class HRecycler<RecycleViewType, RecycleDataType>: Content<PlainView> where RecycleViewType: Recycle<RecycleDataType>, RecycleDataType: Equatable {
    @_spi(Aiuta) public final class ScrollList<RecycleFlipper>: List where RecycleFlipper: HRecycler<RecycleViewType, RecycleDataType> {
        @scrollable var flipper = RecycleFlipper()

        public var data: DataProvider<RecycleDataType>? {
            get { flipper.data }
            set { flipper.data = newValue }
        }

        override func updateLayoutInternal() {
            layout.make { make in
                make.leftRight = 0
                make.height = flipper.itemSize.height + flipper.contentInsets.verticalInsetsSum
            }
            super.updateLayoutInternal()
        }
    }

    public let onRegisterItem = Signal<RecycleViewType>()
    public let onUpdateItem = Signal<RecycleViewType>()
    public let onTapItem = Signal<RecycleViewType>()

    public var canInvalidateLayout: Bool = false
    public var extendedRenderingWidth: CGFloat = 300
    public var partialRenderingWidth: CGFloat = 100
    public var contentInsets: UIEdgeInsets = .zero
    public var contentSpace: CGSize = .zero
    public var itemSize: CGSize = .init(width: 1, height: 1) {
        didSet {
            guard oldValue != itemSize else { return }
            rects.removeAll()
            if canInvalidateLayout {
                invalidateLayout()
            } else {
                updateLayoutInternal()
            }
        }
    }

    public var hasLoadingIndicator = false {
        didSet {
            guard oldValue != hasLoadingIndicator else { return }
            if hasLoadingIndicator { loadingIndicator = LoadingIndicator() }
            else { loadingIndicator = nil }
        }
    }

    private var loadingIndicator: LoadingIndicator? {
        didSet {
            oldValue?.removeFromParent()
            if let loadingIndicator {
                loadingIndicator.isVisible = data?.canUpdate ?? false
                addContent(loadingIndicator)
            }
        }
    }

    public var data: DataProvider<RecycleDataType>? {
        didSet {
            guard oldValue !== data else { return }
            oldValue?.onUpdate.cancelSubscription(for: self)
            loadingIndicator?.isVisible = data?.canUpdate ?? false
            data?.onUpdate.subscribe(with: self, callback: { [unowned self] in
                loadingIndicator?.isVisible = data?.canUpdate ?? false
                if canInvalidateLayout {
                    invalidateLayout()
                } else {
                    updateLayoutInternal()
                }
            })
            guard oldValue?.items != data?.items else { return }
            rects.removeAll()
            items.forEach { item in
                item.isUsed = false
                item.isVisited = false
                item.update(nil, at: item.index)
                item.data = nil
            }
            if let data, data.items.isEmpty {
                data.requestUpdate()
            } else {
                if canInvalidateLayout {
                    invalidateLayout()
                } else {
                    updateLayoutInternal()
                }
            }
        }
    }

    public var placeholderItems: Int = 0

    public var activeCells: [RecycleViewType] {
        items.filter { $0.isUsed }
    }

    public private(set) var firstVisible: RecycleDataType?

    private var rects = RectBatching()
    private var items = [RecycleViewType]()
    private var indexedItems = [Int: RecycleViewType]()
    private var oldFirstItem: RecycleDataType?
    private var lastRenderPartial = Int.min

    private weak var parentHScroll: HScroll? {
        didSet {
            guard oldValue !== parentHScroll else { return }
            oldValue?.didScroll.cancelSubscription(for: self)
            parentHScroll?.didScroll.subscribePast(with: self) { [unowned self] offset, _ in
                guard shouldLayout(offset) else {
                    updateItemsInFocus()
                    return
                }
                updateLayoutInternal()
            }
        }
    }

    private weak var parentVScroll: VScroll? {
        didSet {
            guard oldValue !== parentHScroll else { return }
            oldValue?.didScroll.cancelSubscription(for: self)
            parentVScroll?.didScroll.subscribePast(with: self) { [unowned self] _ in
                updateLayoutInternal()
            }
        }
    }

    public func scroll(to index: Int, animated: Bool = true) {
        rects.batches.forEach { batch in
            batch.forEachRect { i, rect in
                guard i == index else { return }
                parentHScroll?.scroll(to: rect.minX - (layout.screen.width - rect.width) / 2, animated: animated)
            }
        }
    }

    override open func attached() {
        parentHScroll = firstParentOfType()
        parentVScroll = firstParentOfType()
        prefillRecycleBuffer()
    }

    private func shouldLayout(_ offset: CGFloat) -> Bool {
        let renderPartial = getRenderPartial(offset)
        guard renderPartial != lastRenderPartial else { return false }
        lastRenderPartial = renderPartial
        return true
    }

    private func getRenderPartial(_ offset: CGFloat) -> Int {
        return Int(offset / partialRenderingWidth)
    }

    override func updateLayoutInternal() {
        let itemsCount = data?.items.count ?? placeholderItems
        guard layout.boundary.width > 0, layout.boundary.height > 0 else { return }

        if oldFirstItem != data?.items.first || itemsCount < rects.count {
            oldFirstItem = data?.items.first
            rects.removeAll()
        }

        let itemWidth = itemSize.width
        let itemHeigh = itemSize.height
        var left = contentInsets.left
        let renderRect = layout.extendedBounds(extension: .init(width: extendedRenderingWidth, height: extendedRenderingWidth))
        guard renderRect.height > 0 else { return }

        rects.batches.suffix(2).forEach { batch in
            batch.forEachRect { _, rect in
                left = rect.maxX + contentSpace.width
            }
        }

        while rects.count < itemsCount {
            let rect = CGRect(x: left,
                              y: contentInsets.top,
                              width: itemWidth,
                              height: itemHeigh)
            left = rect.maxX + contentSpace.width
            rects.add(rect)
        }

        items.forEach { itemView in
            itemView.isVisited = false
            if data.isSome {
                let frame = itemView.layout.frame
                itemView.isUsed = itemView.data.isSome && frame.size > .zero && frame.intersects(renderRect)
            }
        }

        rects.batches.forEach { batch in
            guard batch.frame.intersects(renderRect) else { return }
            batch.forEachRect { i, rect in
                guard rect.intersects(renderRect) else { return }

                let index = ItemIndex(i, of: itemsCount)
                let item = recycleItemAtIndex(i, withRect: rect)
                let itemData = data?.items[safe: i]

                item.isVisited = true
                if data.isNil {
                    item.isUsed = true
                }

                if item.layout.size != rect.size {
                    item.layout.make { $0.frame = rect }
                    item.updateLayoutRecursive()
                }

                if rect.minX != item.layout.left || rect.minY != item.layout.top {
                    item.layout.make { make in
                        make.left = rect.minX
                        make.top = rect.minY
                    }
                }

                if item.index.item != i || item.data != itemData {
                    item.index = index
                    indexedItems[index.item] = item
                    item.update(itemData, at: ItemIndex(i, of: itemsCount))
                    item.data = itemData
                } else {
                    item.index = index
                    indexedItems[index.item] = item
                }

                onUpdateItem.fire(item)
            }
        }

        items.forEach { itemView in
            if !itemView.isVisited {
                itemView.isUsed = false
                guard itemView.data.isSome else { return }
                itemView.update(nil, at: itemView.index)
                itemView.data = nil
            }
        }

        updateItemsInFocus()

        layout.make { make in
            make.height = itemHeigh + contentInsets.verticalInsetsSum
            let contentWidth: CGFloat = rects.batches.last?.frame.maxX ?? 0
            make.width = contentWidth + contentInsets.right + (loadingIndicator?.layout.width ?? 0)
        }

        loadingIndicator?.layout.make { make in
            make.right = 0
        }

        parentHScroll?.updateLayoutInternal()
        checkForUpdate()
    }

    private func updateItemsInFocus() {
        firstVisible = nil
        var firstVisibleIndex: Int = .max
        let focusRect = layout.visibleBounds

        items.forEach { item in
            guard item.isUsed else { return }

            let isIntersects = focusRect.intersects(item.layout.frame)
            let isContains = focusRect.contains(item.layout.frame)
            if isIntersects, firstVisible.isNil || item.index.item < firstVisibleIndex {
                firstVisibleIndex = item.index.item
                firstVisible = item.data
            }
            item.transitions.isReferenceActive = isIntersects
            item.subcontents.forEach { $0.transitions.isReferenceActive = isIntersects }
            item.setFocus(isPartialVisible: isIntersects, isFullVisible: isContains)
        }
    }

    public func updateItems() {
        items.forEach { item in
            item.update(item.data, at: item.index)
            onUpdateItem.fire(item)
        }
    }

    public convenience init(_ builder: (_ it: HRecycler, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

private extension HRecycler {
    func itemAtIndex(_ index: Int) -> RecycleViewType? {
        if let item = indexedItems[index], item.index.item == index { return item }
        return items.first(where: { $0.index.item == index })
    }

    func recycleItemAtIndex(_ index: Int, withRect rect: CGRect) -> RecycleViewType {
        itemAtIndex(index) ?? recycleItem(withRect: rect)
    }

    func recycleItem(withRect rect: CGRect) -> RecycleViewType {
        for item in items {
            if item.isUsed { continue }
            item.isUsed = true
            return item
        }

        let newItem = RecycleViewType()
        addContent(newItem)
        newItem.layout.make { $0.size = rect.size }
        items.append(newItem)
        onRegisterItem.fire(newItem)
        newItem.onTouchUpInside.subscribe(with: self) { [unowned self, weak newItem] in
            guard let newItem else { return }
            onTapItem.fire(newItem)
        }
        newItem.isUsed = true
        return newItem
    }

    func prefillRecycleBuffer() {
        guard items.isEmpty else { return }
        let availableSize = layout.screen.size - contentInsets
        let bufferSize = Int(availableSize.square / itemSize.square) + 1
        let bufferItemRect = CGRect(origin: .init(x: 0, y: -layout.screen.size.height), size: itemSize)
        guard bufferSize > 0 else { return }
        for i in 0 ..< bufferSize {
            let item = recycleItem(withRect: bufferItemRect)
            item.index = .init(i, of: 0)
            indexedItems[i] = item
        }
        items.forEach { $0.isUsed = false }
    }
}

private extension HRecycler {
    func checkForUpdate() {
        guard let data, data.canUpdate else { return }
        let visibleRect = layout.visibleBounds
        guard visibleRect.width > 0 else { return }
        let willRequestForUpdate = visibleRect.maxX >= layout.bounds.maxX - layout.screen.width
        if willRequestForUpdate { data.requestUpdate() }
    }
}

private extension HRecycler {
    final class LoadingIndicator: Plane {
        let spinner = Spinner { it, _ in
            it.isSpinning = false
        }

        var isVisible = false {
            didSet {
                guard oldValue != isVisible else { return }
                spinner.isSpinning = isVisible
                guard !isVisible else { return }
                animations.animate { [self] in
                    parentScroll?.update()
                }
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.top = 0
                make.bottom = 0
                make.width = isVisible ? 80 : 0
            }

            spinner.layout.make { make in
                make.center = .zero
            }
        }

        var parentScroll: HScroll? {
            firstParentOfType()
        }
    }
}
