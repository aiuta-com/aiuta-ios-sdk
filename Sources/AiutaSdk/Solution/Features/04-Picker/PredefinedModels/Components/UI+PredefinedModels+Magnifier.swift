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
import UIKit

final class PredefinedModelsMagnifier: HScroll {
    let onSelect = Signal<Aiuta.Image>()

    var images: [Aiuta.Image]? {
        didSet {
            view.isUserInteractionEnabled = true
            Zip(images, imageViews).longest.forEach { image, imageView in
                guard let image else {
                    imageView?.removeFromParent()
                    return
                }

                if let imageView {
                    imageView.image = image
                } else {
                    addContent(ImageView()).image = image
                }
            }
            updateLayout()
            layoutContents()
            selected = images?[safe: itemIndex]
            if oldValue.isSome {
                animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
            }
        }
    }

    private(set) var selected: Aiuta.Image? {
        didSet {
            guard oldValue != selected, let selected else { return }
            onSelect.fire(selected)
        }
    }

    private var imageViews: [ImageView] {
        findChildren()
    }

    private let itemSize = CGSize(width: 66, height: 106)
    private let focusSize = CGSize(width: 76, height: 124)
    private var generator: UIImpactFeedbackGenerator?
    private var itemsCount: Int { images?.count ?? 0 }

    private var itemIndex: Int = 0 {
        didSet {
            guard oldValue != itemIndex else { return }
            selected = images?[safe: itemIndex]
            generator?.impactOccurred()
        }
    }

    fileprivate func select(_ image: Aiuta.Image) {
        guard let index = images?.firstIndex(of: image) else { return }
        scroll(to: offsetFromIndex(index))
    }

    override func setup() {
        itemSpace = 6
        isLayoutEnabled = false

        if #available(iOS 17.5, *) {
            generator = UIImpactFeedbackGenerator(style: .light, view: container)
        } else {
            generator = UIImpactFeedbackGenerator(style: .light)
        }

        appearance.make { make in
            make.bounces = true
            make.showsHorizontalScrollIndicator = false
            make.showsVerticalScrollIndicator = false
            make.contentInsetAdjustmentBehavior = .never
            make.decelerationRate = .fast
            make.backgroundColor = .clear
        }

        willBeginDragging.subscribe(with: self) { [unowned self] in
            generator?.prepare()
        }

        didScroll.subscribe(with: self) { [unowned self] offset, _ in
            updatePageIndex(offset - contentInset.left)
            layoutContents()
        }

        didEndDragging.subscribe(with: self) { [unowned self] velocity, targetContentOffset in
            let iw: CGFloat = 66
            var index: Int = indexFromOffset(targetContentOffset.pointee.x + velocity.x * iw, clamped: false)
            index = clamp(index, min: 0, max: itemsCount - 1)
            targetContentOffset.pointee.x = offsetFromIndex(index)
        }

        for _ in 0 ... 6 {
            addContent(ImageView())
        }

        view.isUserInteractionEnabled = false
    }

    private func updatePageIndex(_ offset: CGFloat) {
        guard layout.width > 0, itemsCount > 0 else { return }
        itemIndex = indexFromOffset(offset)
    }

    private func offsetFromIndex(_ index: Int) -> CGFloat {
        let i = CGFloat(index)
        return (itemSize.width + itemSpace) * i - contentInset.left
    }

    private func indexFromOffset(_ offset: CGFloat, clamped: Bool = true) -> Int {
        let i = (offset + contentInset.left) / (itemSize.width + itemSpace)
        let unboundIndex = Int(round(i))
        return clamped ? clamp(unboundIndex, min: 0, max: itemsCount - 1) : unboundIndex
    }

    override func updateLayout() {
        let inset = (layout.width - focusSize.width) / 2
        contentInset = .init(left: inset, right: inset)
        contentSize = .init(width: layoutContents(), height: layout.height)
    }

    @discardableResult
    private func layoutContents() -> CGFloat {
        var left: CGFloat = 0
        subcontents.indexed.forEach { i, sub in
            sub.layout.make { make in make.left = left }
            let distanceFromFocus: CGFloat = abs(sub.layout.left - contentOffset.x - contentInset.left)
            var minify: CGFloat = clamp(distanceFromFocus / itemSize.width, min: 0, max: 1)
            if i == itemsCount - 1, view.isAtRight { minify = 0 }
            if i == 0, view.isAtLeft { minify = 0 }
            sub.layout.make { make in
                make.width = focusSize.width - (focusSize.width - itemSize.width) * minify
                make.height = focusSize.height - (focusSize.height - itemSize.height) * minify
                make.radius = min(8, ds.shapes.imageM.radius)
                make.centerY = 0
            }
            sub.updateLayout()
            left = sub.layout.rightPin + itemSpace
        }
        return max(0, left - itemSpace)
    }
}

private extension PredefinedModelsMagnifier {
    final class ImageView: PlainButton {
        var image: Aiuta.Image? {
            didSet {
                imageView.source = image
            }
        }

        let imageView = Image { it, _ in
            it.isAutoSize = false
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
        }

        var magnifier: PredefinedModelsMagnifier? {
            firstParentOfType()
        }

        override func setup() {
            view.backgroundColor = ds.colors.neutral

            onTouchUpInside.subscribe(with: self) { [unowned self] in
                guard let image else { return }
                magnifier?.select(image)
            }
        }

        override func updateLayout() {
            imageView.layout.make { make in
                make.inset = 0
            }
        }
    }
}
