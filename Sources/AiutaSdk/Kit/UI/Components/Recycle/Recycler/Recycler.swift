//
//  Created by nGrey on 08.06.2023.
//

import UIKit

class Recycler<RecycleViewType, RecycleDataType>: Content<PlainView> where RecycleViewType: Recycle<RecycleDataType>, RecycleDataType: Equatable {
    let onRegisterItem = Signal<RecycleViewType>()
    let onUpdateItem = Signal<RecycleViewType>()
    let onTapItem = Signal<RecycleViewType>()

    var useSampler: Bool = false
    var canInvalidateLayout: Bool = true
    var extendedRenderingHeightMultiplyer: CGFloat = 2
    var contentInsets: UIEdgeInsets = .zero
    var contentSpace: CGSize = .zero
    var contentFraction: SizeFractions = .init(width: .fraction(1), height: .widthMultiplyer(1)) {
        didSet {
            guard oldValue != contentFraction else { return }
            rects.removeAll()
            if canInvalidateLayout {
                invalidateLayout()
            }
        }
    }

    var data: DataProvider<RecycleDataType>? {
        didSet {
            guard oldValue !== data else { return }
            oldValue?.onUpdate.cancelSubscription(for: self)
            if canInvalidateLayout {
                data?.onUpdate.subscribe(with: self, callback: { [unowned self] in
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
    
    var activeCells: [RecycleViewType] {
        items.filter { $0.isUsed }
    }

    private(set) var firstVisible: RecycleDataType?

    private var rects = RectBatching()
    private var items = [RecycleViewType]()
    private var indexedItems = [Int: RecycleViewType]()
    private let sampler = RecycleViewType()
    private var oldFirstItem: RecycleDataType?
    private var calculatedWidth: CGFloat = 0
    private weak var parentScroll: VScroll?

    override func attached() {
        sampler.appearance.make { make in
            make.isUserInteractionEnabled = false
            make.isVisible = false
        }
        parentScroll = firstParentOfType()
        parentScroll?.didChangeOffset.subscribePast(with: self, callback: { [unowned self] _, _ in
            updateLayoutInternal()
            // checkForUpdate()
        })
        prefillRecycleBuffer()
    }

    override func updateLayoutInternal() {
        guard let data else { return }
        guard layout.boundary.width > 0 else { return }

        if oldFirstItem != data.items.first || data.items.count < rects.count {
            oldFirstItem = data.items.first
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
        var visibleRect = layout.visible
        var visibleNotExtendedRect = visibleRect
        if let insets = parentScroll?.contentInset {
            visibleNotExtendedRect.origin.y += insets.top
            visibleNotExtendedRect.size.height -= insets.verticalInsetsSum
        }

        if extendedRenderingHeightMultiplyer > 1, visibleRect.size > .zero {
            visibleRect = visibleRect.fill(.init(width: visibleRect.width, height: visibleRect.height * extendedRenderingHeightMultiplyer))
        }

        rects.batches.suffix(2).forEach { batch in
            batch.forEachRect { index, rect in
                let col = index.roll(countOfItemsInRow)
                topInColumn[col] = rect.maxY + contentSpace.height
            }
        }

        while rects.count < data.items.count {
            let index = rects.count
            let col = index.roll(countOfItemsInRow)
            if useSampler {
                sampler.update(data.items[safe: index], at: ItemIndex(index, of: data.items.count))
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
            itemView.isUsed = itemView.data.isSome && frame.size > .zero && frame.intersects(visibleRect)
        }

        firstVisible = nil
        rects.batches.forEach { batch in
            guard batch.frame.intersects(visibleRect) else { return }
            batch.forEachRect { i, rect in
                guard rect.intersects(visibleRect) else { return }
                let index = ItemIndex(i, of: data.items.count)
                let item = recycleItemAtIndex(i, withRect: rect)
                item.isVisited = true

                let itemData = data.items[safe: i]
                if firstVisible.isNil, visibleNotExtendedRect.intersects(rect) {
                    firstVisible = itemData
                }

                let inFocus = visibleNotExtendedRect.intersects(rect)
                item.subcontents.forEach { $0.transitions.isReferenceActive = inFocus }

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
                    item.update(itemData, at: ItemIndex(i, of: data.items.count))
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
                itemView.update(nil, at: itemView.index)
                itemView.data = nil
            }
        }

        layout.make { make in
            make.width = layout.boundary.width
            let contentHeight: CGFloat = rects.batches.last?.frame.maxY ?? 0
            make.height = contentHeight + contentInsets.bottom
        }

        parentScroll?.updateLayoutInternal()
        checkForUpdate()
    }

    func updateItems() {
        items.forEach { item in
            item.update(item.data, at: item.index)
            onUpdateItem.fire(item)
        }
    }

    convenience init(_ builder: (_ it: Recycler, _ ds: DesignSystem) -> Void) {
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
        // trace("Create recycling \(RecycleViewType.self) #\(items.count)")
        newItem.didInvalidate.subscribe(with: self) { [unowned self] invalidData in
            invalidate(data: invalidData)
        }
        newItem.onTouchUpInside.subscribe(with: self) { [unowned self, weak newItem] in
            guard let newItem else { return }
            onTapItem.fire(newItem)
        }
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
            item.isUsed = true
        }
        items.forEach { $0.isUsed = false }
        // trace("Recycle buffer filled", availableSize, itemSize, bufferSize)
    }
}

private extension Recycler {
    func checkForUpdate() {
        guard let data, data.canUpdate else { return }
        let visibleRect = layout.visible
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
