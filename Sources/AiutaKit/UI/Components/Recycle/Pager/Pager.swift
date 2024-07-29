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

@_spi(Aiuta) open class Pager<DataType, ItemView: Page<DataType>>: Plane {
    public let onSwipePage = Signal<Int>()

    public var data: DataProvider<DataType>? {
        didSet {
            guard oldValue !== data else { return }
            pageCount = data?.items.count ?? 0
            oldValue?.onUpdate.cancelSubscription(for: self)
            data?.onUpdate.subscribe(with: self) { [unowned self] in
                pageCount = data?.items.count ?? 0
                updateDataOnPages()
                checkForUpdate()
            }
        }
    }

    public let galleryView = HScroll()

    public var galleryInset: CGFloat = 0
    public var gallerySpace: CGFloat = 0

    public var pageIndex: Int = 0 {
        didSet {
            guard oldValue != pageIndex else { return }
            swapPages(from: oldValue, to: pageIndex)
            onSwipePage.fire(pageIndex)
            checkForUpdate()
        }
    }

    private var dragIndex: Int = 0
    private var startDragAtFootTop = false
    private var isDragging = false {
        didSet { pages.forEach { $0.isBeingDrag = isDragging } }
    }

    public private(set) var pageCount: Int = 0 {
        didSet {
            guard oldValue != pageCount else { return }
            galleryView.contentSize = .init(width: contentWidth(for: pageCount),
                                            height: layout.height)
            updateDataOnPages()
            onSwipePage.fire(pageIndex)
        }
    }

    public var currentItem: DataType? {
        data?.items[safe: pageIndex]
    }

    public var currentPage: ItemView? {
        pages.first(where: { $0.index == pageIndex })
    }

    public var pages: [ItemView] {
        galleryView.findChildren()
    }

    public func scroll(to index: Int) {
        galleryView.view.setContentOffset(.init(x: offsetFromIndex(index) - galleryInset / 2, y: 0), animated: true)
    }

    override func setupInternal() {
        galleryView.isLayoutEnabled = false
        galleryView.appearance.make { make in
            make.bounces = true
            make.showsHorizontalScrollIndicator = false
            make.showsVerticalScrollIndicator = false
            make.contentInsetAdjustmentBehavior = .never
            make.decelerationRate = .fast
            make.backgroundColor = .clear
        }
        galleryView.willBeginDragging.subscribe(with: self) { [unowned self] in
            dragIndex = pageIndex
            isDragging = true
        }
        galleryView.didScroll.subscribe(with: self) { [unowned self] offset, _ in
            updatePageIndex(offset)
        }
        galleryView.didFinishScroll.subscribe(with: self) { [unowned self] in
            isDragging = false
        }
        galleryView.didEndDragging.subscribe(with: self) { [unowned self] velocity, targetContentOffset in
            let iw = layout.width - galleryInset + gallerySpace
            var index: Int = indexFromOffset(targetContentOffset.pointee.x + velocity.x * iw, clamped: false)
            if index > dragIndex { index = dragIndex + 1 }
            if index < dragIndex { index = dragIndex - 1 }
            index = clamp(index, min: 0, max: pageCount - 1)
            targetContentOffset.pointee.x = offsetFromIndex(index) - galleryInset / 2
        }
        for i in 0 ... 2 {
            galleryView.addContent(ItemView()) { it, _ in
                it.setIndex(i, relativeTo: pageIndex)
            }
        }
    }

    override func updateLayoutInternal() {
        galleryView.layout.make { make in
            make.size = layout.size
        }

        pages.forEach { page in
            page.layout.make { make in
                make.height = layout.height
                make.width = layout.width - galleryInset
                make.left = offsetFromIndex(page.index)
            }
        }

        galleryView.contentSize = .init(width: contentWidth(for: pageCount), height: layout.height)
        galleryView.contentOffset = .init(x: offsetFromIndex(pageIndex) - galleryInset / 2, y: 0)
    }

    public convenience init(_ builder: (_ it: Pager, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

private extension Pager {
    func offsetFromIndex(_ index: Int) -> CGFloat {
        let i = CGFloat(index)
        let itemWidth = layout.width - galleryInset
        return (itemWidth + gallerySpace) * i + galleryInset / 2
    }

    func indexFromOffset(_ offset: CGFloat, clamped: Bool = true) -> Int {
        let itemWidth = layout.width - galleryInset
        let i = (offset - galleryInset / 2) / (itemWidth + gallerySpace)
        let unboundIndex = Int(round(i))
        return clamped ? clamp(unboundIndex, min: 0, max: pageCount - 1) : unboundIndex
    }

    func contentWidth(for count: Int) -> CGFloat {
        CGFloat(count) * (layout.width - galleryInset) + galleryInset + gallerySpace * CGFloat(max(0, count - 1))
    }

    func updatePageIndex(_ offset: CGFloat) {
        guard layout.width > 0, pageCount > 0 else { return }
        pageIndex = indexFromOffset(offset)
    }

    func updateDataOnPages() {
        pages.forEach { page in
            setPage(page, index: page.index)
        }
    }

    func swapPages(from oldIndex: Int, to newIndex: Int) {
        guard abs(newIndex - oldIndex) == 1 else {
            reindexPages(to: newIndex)
            return
        }
        let nextIndex = newIndex > oldIndex ? newIndex + 1 : newIndex - 1
        pages.forEach { page in
            guard page.index != oldIndex, page.index != newIndex else {
                page.setIndex(page.index, relativeTo: pageIndex)
                return
            }
            setPage(page, index: nextIndex)
        }
    }

    func reindexPages(to newIndex: Int) {
        pages.indexed.forEach { i, page in
            setPage(page, index: newIndex + i - 1)
        }
    }

    func setPage(_ page: ItemView, index: Int) {
        page.setIndex(index, relativeTo: pageIndex)
        page.data = data?.items[safe: index]

        page.layout.make { make in
            make.left = offsetFromIndex(index)
        }
    }

    func checkForUpdate() {
        if pageIndex > pageCount - 5 {
            data?.requestUpdate()
        }
    }
}
