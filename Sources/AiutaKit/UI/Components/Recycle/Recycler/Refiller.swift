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

@_spi(Aiuta) open class Filler<FillViewType, FillDataType>: Content<PlainView> where FillViewType: Recycle<FillDataType>, FillDataType: AnyObject {
    public enum Direction {
        case up, down
    }

    public let onRegisterItem = Signal<FillViewType>()

    public var contentInsets: UIEdgeInsets = .zero
    public var contentSpace: CGSize = .zero
    public var contentFraction: CGSize = .init(square: 1) {
        didSet {
            guard oldValue != contentFraction else { return }
            invalidateLayout()
        }
    }

    public var fillLimit: Int?
    public var fillDirection: Direction = .down {
        didSet {
            guard oldValue != fillDirection else { return }
            invalidateLayout()
        }
    }

    public var dataMayUpdate = false
    public var isPaginationEnabled = true
    public var dataChunkSize: Int = 1
    public var constantData: [FillDataType]? {
        didSet {
            guard let constantData else {
                dataProvider = nil
                return
            }

            let partialData = PartialDataProvider(constantData)
            partialData.chunkSize = dataChunkSize
            dataProvider = partialData
            if partialData.items.isEmpty {
                partialData.requestUpdate()
            }
        }
    }

    public var dataProvider: DataProvider<FillDataType>? {
        didSet {
            guard oldValue !== dataProvider else { return }
            oldValue?.onUpdate.cancelSubscription(for: self)
            dataProvider?.onUpdate.subscribe(with: self, callback: { [unowned self] in
                invalidateLayout()
            })
            parentScroll?.updateLayoutRecursive()
        }
    }

    private var items = [FillViewType]()
    private weak var parentScroll: VScroll?

    override open func attached() {
        parentScroll = firstParentOfType()
        parentScroll?.didChangeOffset.subscribePast(with: self, callback: { [unowned self] _, _ in
            updateLayoutInternal()
            // checkForUpdate()
        })
    }

    private func checkForUpdate() {
        guard isPaginationEnabled, let dataProvider, dataProvider.canUpdate else { return }
        let visibleRect = layout.visibleBounds
        guard visibleRect.height > 0 else { return }
        let willRequestForUpdate = visibleRect.maxY >= layout.bounds.maxY - layout.screen.height
        if willRequestForUpdate { dataProvider.requestUpdate() }
    }

    func updateItems() {
        guard let dataProvider else { return }
        items.indexed.forEach { index, item in
            guard item.data !== dataProvider.items[safe: index] else { return }
            item.update(dataProvider.items[safe: index], at: .init(index, of: dataProvider.items.count))
            item.data = dataProvider.items[safe: index]
            item.isUsed = true
        }
    }

    override func updateLayoutInternal() {
        guard let dataProvider else { return }
        guard layout.boundary.width > 0 else { return }

        let contentFractionWidth = min(1, contentFraction.width)
        let countOfItemsInRow = Int(1 / contentFractionWidth)
        let awailableWidth = layout.boundary.width - contentInsets.horizontalInsetsSum
        let spacersWidthSum = contentSpace.width * CGFloat(countOfItemsInRow - 1)
        let itemWidth = (awailableWidth - spacersWidthSum) * contentFractionWidth
        let itemHeigh = itemWidth * contentFraction.height / contentFraction.width
        var topInColumn = [CGFloat](repeating: contentInsets.top, count: countOfItemsInRow)
        var contentHeight: CGFloat = 0
        let visibleRect = layout.visibleBounds

        let limit: Int = fillLimit ?? .max
        while items.count < min(dataProvider.items.count, limit) {
            let index = items.count
            let item = createItem()
            if !dataMayUpdate {
                item.update(dataProvider.items[safe: index], at: .init(index, of: dataProvider.items.count))
                item.data = dataProvider.items[safe: index]
                item.isUsed = true
            }
            item.layout.make { make in
                make.width = itemWidth
            }
            item.updateLayoutRecursive()
        }

        if dataMayUpdate { updateItems() }

        let directionalItems: [FillViewType]
        switch fillDirection {
            case .up: directionalItems = items.reversed()
            case .down: directionalItems = items
        }

        directionalItems.indexed.forEach { index, item in
            if let fillLimit, index >= fillLimit {
                item.update(nil, at: .init(0, of: 0))
                item.data = nil
                item.isUsed = false
                removeContent(item)
                return
            }
            let col = index.roll(countOfItemsInRow)
            item.layout.make { make in
                make.width = itemWidth
                if make.height == 0 { make.height = itemHeigh }
                make.left = contentInsets.left + (contentSpace.width + itemWidth) * CGFloat(col)
                make.top = topInColumn[safe: col] ?? contentInsets.top
            }
            topInColumn[col] = item.layout.bottomPin + contentSpace.height
            contentHeight = max(contentHeight, topInColumn[col])

            if fillLimit.isNil {
                item.view.isVisible = item.layout.frame.intersects(visibleRect)
                if !item.layout.isEnabled, item.view.isVisible {
                    item.view.setNeedsLayout()
                }
                item.layout.isEnabled = item.view.isVisible
            }
        }

        layout.make { make in
            make.width = layout.boundary.width
            make.height = contentHeight + contentInsets.bottom
        }

        parentScroll?.updateLayoutInternal()
        checkForUpdate()
    }

    private func createItem() -> FillViewType {
        let newItem = FillViewType()
        addContent(newItem)
        items.append(newItem)
        onRegisterItem.fire(newItem)
        newItem.didInvalidate.subscribe(with: self) { [unowned self] _ in
            parentScroll?.updateLayoutRecursive()
        }
        return newItem
    }

    public convenience init(_ builder: (_ it: Filler, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
