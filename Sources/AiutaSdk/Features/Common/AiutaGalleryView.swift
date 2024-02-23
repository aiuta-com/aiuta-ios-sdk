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

class AiutaGalleryView<DataType, ItemView: AiutaGalleryItemView<DataType>>: Plane {
    var data: DataProvider<DataType>? {
        didSet {
            guard let data else {
                pageCount = 0
                return
            }

            pageCount = data.items.count
        }
    }

    let galleryView = HScroll()

    var galleryViewInset: CGFloat = 92

    var pageIndex: Int = 0 {
        didSet {
            guard oldValue != pageIndex else { return }
            swapPages(from: oldValue, to: pageIndex)
//            onSwipePage.fire(pageIndex)
//            checkForUpdate()
        }
    }

    var dragIndex: Int = 0
    private var startDragAtFootTop = false

    var pageCount: Int = 0 {
        didSet {
            guard oldValue != pageCount else { return }
            galleryView.contentSize = .init(width: CGFloat(pageCount) * (layout.width - galleryViewInset) + galleryViewInset, height: layout.height)
            updateDataOnPages()
//            onSwipePage.fire(pageIndex)
        }
    }

    var currentPage: ItemView? {
        pages.first(where: { $0.index == pageIndex })
    }

    var pages: [ItemView] {
        galleryView.findChildren()
    }

    override func setup() {
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
        }
        galleryView.didScroll.subscribe(with: self) { [unowned self] offset, _ in
            updatePageIndex(offset)
        }
        galleryView.didEndDragging.subscribe(with: self) { [unowned self] velocity, targetContentOffset in
            let iw = (layout.width - galleryViewInset)
            var index: Int = Int(round((targetContentOffset.pointee.x + velocity.x * iw) / iw))
            if index > dragIndex { index = dragIndex + 1 }
            if index < dragIndex { index = dragIndex - 1 }
            index = clamp(index, min: 0, max: pageCount - 1)
            targetContentOffset.pointee.x = iw * CGFloat(index)
        }
        for i in 0 ... 2 {
            galleryView.addContent(ItemView()) { it, _ in
                it.setIndex(i, relativeTo: pageIndex)
            }
        }
    }

    override func updateLayout() {
        galleryView.layout.make { make in
            make.size = layout.size
        }

        pages.forEach { page in
            page.layout.make { make in
                make.height = layout.height
                make.width = layout.width - galleryViewInset
                make.left = make.width * CGFloat(page.index) + galleryViewInset / 2
            }
        }

        galleryView.contentSize = .init(width: CGFloat(pageCount) * (layout.width - galleryViewInset) + galleryViewInset, height: layout.height)
        galleryView.contentOffset = .init(x: CGFloat(pageIndex) * (layout.width - galleryViewInset), y: 0)
    }

    func scroll(to index: Int) {
        galleryView.view.setContentOffset(.init(x: CGFloat(index) * (layout.width - galleryViewInset), y: 0), animated: true)
    }
}

private extension AiutaGalleryView {
    func updatePageIndex(_ offset: CGFloat) {
        guard layout.width > 0, pageCount > 0 else { return }
        pageIndex = clamp(Int(round(offset / (layout.width - galleryViewInset))), min: 0, max: pageCount - 1)
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
        page.update(data?.items[safe: index])

        page.layout.make { make in
            make.left = make.width * CGFloat(index) + galleryViewInset / 2
        }
    }
}

class AiutaGalleryItemView<DataType>: Plane {
    private(set) var index: Int = 0

    func setIndex(_ newIndex: Int, relativeTo currentIndex: Int) {
        index = newIndex
        if index == currentIndex {
            bringToFront()
        }
    }

    func update(_ data: DataType?) { }
}
