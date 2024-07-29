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

@_spi(Aiuta) open class Recycler<RecycleViewType, RecycleDataType>: Content<PlainView> where RecycleViewType: Recycle<RecycleDataType>, RecycleDataType: Equatable {
    public let onRegisterItem = Signal<RecycleViewType>()
    public let onUpdateItem = Signal<RecycleViewType>()
    public let onTapItem = Signal<RecycleViewType>()

    public var useSampler: Bool = false
    public var canInvalidateLayout: Bool = true
    public var extendedRenderingHeight: CGFloat = 300
    public var partialRenderingHeight: CGFloat = 100
    public var contentInsets: UIEdgeInsets = .zero
    public var contentSpace: CGSize = .zero
    public var contentFraction: SizeFractions = .init(width: .fraction(1), height: .widthMultiplyer(1)) {
        didSet {
            guard oldValue != contentFraction else { return }
            rects.removeAll()
            if canInvalidateLayout {
                invalidateLayout()
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
            if canInvalidateLayout {
                data?.onUpdate.subscribe(with: self, callback: { [unowned self] in
                    loadingIndicator?.isVisible = data?.canUpdate ?? false
                    invalidateLayout()
                })
            }
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
    private let sampler = RecycleViewType()
    private var oldFirstItem: RecycleDataType?
    private var calculatedWidth: CGFloat = 0
    private var lastRenderPartial = Int.min

    private weak var parentScroll: VScroll? {
        didSet {
            guard oldValue !== parentScroll else { return }
            oldValue?.didChangeOffset.cancelSubscription(for: self)
            parentScroll?.didChangeOffset.subscribePast(with: self) { [unowned self] offset, _ in
                guard shouldLayout(offset) else {
                    updateItemsInFocus()
                    return
                }
                updateLayoutInternal()
            }
        }
    }

    public func scroll(to index: Int, animated: Bool = true) {
        rects.batches.forEach { batch in
            batch.forEachRect { i, rect in
                guard i == index else { return }
                parentScroll?.scroll(to: rect.minY - (layout.screen.height - rect.height) / 2, animated: animated)
            }
        }
    }

    override open func attached() {
        sampler.appearance.make { make in
            make.isUserInteractionEnabled = false
            make.isVisible = false
        }
        parentScroll = firstParentOfType()
        prefillRecycleBuffer()
    }

    private func shouldLayout(_ offset: CGFloat) -> Bool {
        let renderPartial = getRenderPartial(offset)
        guard renderPartial != lastRenderPartial else { return false }
        lastRenderPartial = renderPartial
        return true
    }

    private func getRenderPartial(_ offset: CGFloat) -> Int {
        return Int(offset / partialRenderingHeight)
    }

    override func updateLayoutInternal() {
        let itemsCount = data?.items.count ?? placeholderItems
        guard layout.boundary.width > 0 else { return }

        if oldFirstItem != data?.items.first || itemsCount < rects.count {
            oldFirstItem = data?.items.first
            rects.removeAll()
        }

        if calculatedWidth != layout.boundary.width {
            calculatedWidth = layout.boundary.width
            rects.removeAll()
        }

        let availableSize = layout.boundary.size - contentInsets
        let itemSize = contentFraction.calculateItemSize(availableSize: availableSize, withSpacer: contentSpace)

        let countOfItemsInRow = Int(floor(availableSize.width / itemSize.width))
        let itemWidth = itemSize.width
        let itemHeigh = itemSize.height
        var topInColumn = [CGFloat](repeating: contentInsets.top, count: countOfItemsInRow)
        let renderRect = layout.extendedBounds(extension: .init(width: 0, height: extendedRenderingHeight))

        rects.batches.suffix(2).forEach { batch in
            batch.forEachRect { index, rect in
                let col = index.roll(countOfItemsInRow)
                topInColumn[col] = rect.maxY + contentSpace.height
            }
        }

        while rects.count < itemsCount {
            let index = rects.count
            let col = index.roll(countOfItemsInRow)
            if useSampler {
                sampler.update(data?.items[safe: index], at: ItemIndex(index, of: itemsCount))
                sampler.layout.make { make in
                    make.width = itemWidth
                    make.height = itemHeigh
                    make.left = contentInsets.left + (contentSpace.width + itemWidth) * CGFloat(col)
                    make.top = topInColumn[safe: col] ?? contentInsets.top
                }
                sampler.updateLayoutRecursive()
                topInColumn[col] = sampler.layout.bottomPin + contentSpace.height
                rects.add(sampler.layout.frame)
            } else {
                let rect = CGRect(x: contentInsets.left + (contentSpace.width + itemWidth) * CGFloat(col),
                                  y: topInColumn[safe: col] ?? contentInsets.top,
                                  width: itemWidth,
                                  height: itemHeigh)
                topInColumn[col] = rect.maxY + contentSpace.height
                rects.add(rect)
            }
        }

        if useSampler {
            sampler.update(nil, at: .init(0, of: 0))
        }

        items.forEach { itemView in
            itemView.isVisited = false
            let frame = itemView.layout.frame
            itemView.isUsed = itemView.data.isSome && frame.size > .zero && frame.intersects(renderRect)
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
            make.width = layout.boundary.width
            let contentHeight: CGFloat = rects.batches.last?.frame.maxY ?? 0
            make.height = contentHeight + contentInsets.bottom + (loadingIndicator?.layout.height ?? 0)
        }

        loadingIndicator?.layout.make { make in
            make.bottom = 0
        }

        parentScroll?.updateLayoutInternal()
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

    public convenience init(_ builder: (_ it: Recycler, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

private extension Recycler {
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
        newItem.didInvalidate.subscribe(with: self) { [unowned self] invalidData in
            invalidate(data: invalidData)
        }
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
        let itemSize = contentFraction.calculateItemSize(availableSize: availableSize, withSpacer: contentSpace)
        let bufferSize = Int(availableSize.square / itemSize.square) + Int(availableSize.width / itemSize.width)
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

private extension Recycler {
    func checkForUpdate() {
        guard let data, data.canUpdate else { return }
        let visibleRect = layout.visibleBounds
        guard visibleRect.height > 0 else { return }
        let willRequestForUpdate = visibleRect.maxY >= layout.bounds.maxY - layout.screen.height
        if willRequestForUpdate { data.requestUpdate() }
    }

    func invalidate(data invalidData: RecycleDataType) {
        guard useSampler else { return }
        // guard let index = data?.items.firstIndex(where: { $0 == invalidData }) else { return }
        rects.removeAll() // TODO: rects.removeLast(rects.count - index)
        parentScroll?.updateLayoutRecursive()
    }
}

private extension Recycler {
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
                make.leftRight = 0
                make.height = isVisible ? 80 : 0
            }

            spinner.layout.make { make in
                make.center = .zero
            }
        }

        var parentScroll: VScroll? {
            firstParentOfType()
        }
    }
}

private final class RectBatching {
    private(set) var batches = [RectBatch]()

    var count: Int {
        guard let last = batches.last else { return 0 }
        return last.count + RectBatch.batchSize * (batches.count - 1)
    }

    func add(_ rect: CGRect) {
        if let batch = batches.last, batch.canFit {
            batch.add(rect)
            return
        }

        let batch = RectBatch(startIndex: batches.count * RectBatch.batchSize)
        batches.append(batch)
        batch.add(rect)
    }

    func removeAll() {
        batches.removeAll(keepingCapacity: true)
    }
}

private final class RectBatch {
    static let batchSize: Int = 20

    private(set) var frame: CGRect = .init(x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude, size: .zero)
    private var rects = [CGRect]()

    private let startIndex: Int

    var count: Int {
        rects.count
    }

    var canFit: Bool {
        rects.count < RectBatch.batchSize
    }

    init(startIndex: Int) {
        self.startIndex = startIndex
    }

    func add(_ rect: CGRect) {
        rects.append(rect)
        if rect.minX < frame.minX {
            frame.origin.x = rect.origin.x
        }
        if rect.minY < frame.minY {
            frame.origin.y = rect.origin.y
        }
        if rect.maxX > frame.maxX {
            frame.size.width = rect.maxX - frame.minX
        }
        if rect.maxY > frame.maxY {
            frame.size.height = rect.maxY - frame.minY
        }
    }

    func forEachRect(_ iterator: (Int, CGRect) -> Void) {
        rects.indexed.forEach { i, rect in
            iterator(startIndex + i, rect)
        }
    }
}
