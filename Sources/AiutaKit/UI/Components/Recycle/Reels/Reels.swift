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

@_spi(Aiuta) open class Reels<ReelViewType, ReelDataType>: PlainButton where ReelViewType: Reel<ReelDataType>, ReelDataType: AnyObject {
    public let onPullDown = Signal<Void>()
    public let onPullUp = Signal<Void>()
    public let onIndexChanged = Signal<ItemIndex>()
    public var didScroll = Signal<CGFloat>()

    public var data: DataProvider<ReelDataType>? {
        didSet {
            currentItemIndex = 0
            data?.onUpdate.subscribe(with: self) { [unowned self] in
                updateReels()
            }
            onIndexChanged.fire(currentIndex)
        }
    }

    public var hasData: Bool {
        guard let data else { return false }
        return !data.isEmpty
    }

    public var currentData: ReelDataType? {
        get { data?.items[safe: currentItemIndex] }
        set {
            guard let newValue else { return }
            if let index = data?.items.firstIndex(where: { $0 === newValue }) {
                currentItemIndex = index
            }
        }
    }

    public var nextData: ReelDataType? {
        data?.items[safe: currentItemIndex + 1]
    }

    public var prevData: ReelDataType? {
        data?.items[safe: currentItemIndex - 1]
    }

    public private(set) var currentIndex = ItemIndex(0, of: 0) {
        didSet { onIndexChanged.fire(currentIndex) }
    }

    public var currentReel: ReelViewType {
        reels[reelsCount]
    }

    public var nextReel: ReelViewType {
        reels[reelsCount + 1]
    }

    public var prevReel: ReelViewType {
        reels[reelsCount - 1]
    }

    public private(set) var reels = [ReelViewType]()
    private let reelsCount = 2

    private var currentItemIndex: Int = -1 {
        didSet {
            updateReels()
        }
    }

    private func updateReels() {
        makeReels()
        let dataItemsCount = data?.items.count ?? 0
        reels[reelsCount].update(data?.items[safe: currentItemIndex], at: currentIndex, isCurrent: true)
        reels[reelsCount].view.isVisible = true
        if reelsCount > 0 { for i in 1 ... reelsCount {
            reels[reelsCount - i].update(data?.items[safe: currentItemIndex - i], at: ItemIndex(currentItemIndex - i, of: dataItemsCount), isCurrent: false)
            reels[reelsCount + i].update(data?.items[safe: currentItemIndex + i], at: ItemIndex(currentItemIndex + i, of: dataItemsCount), isCurrent: false)
            reels[reelsCount - i].view.isVisible = (i == 1) && (data?.items[safe: currentItemIndex - i]).isSome
            reels[reelsCount + i].view.isVisible = (i == 1) && (data?.items[safe: currentItemIndex + i]).isSome
            reels[reelsCount - i].sendBelow(reels[reelsCount])
            reels[reelsCount + i].sendBelow(reels[reelsCount])
        }}
        currentIndex = ItemIndex(currentItemIndex, of: dataItemsCount)
        if currentItemIndex > dataItemsCount - 5 {
            data?.requestUpdate()
        }
    }

    public var itemSpace: CGFloat = 16

    public var panToPull: CGFloat = 100
    public var panToSwipe: CGFloat = 180
    public var velocityToSwipe: CGFloat = 500

    private var isUserAttended = false
    private var isPulledInCurrentPan = false
    private var willPanByVelocity = true
    private var didPanByVelocity = false
    public var panEnabled = true
    public private(set) var panOffset: CGFloat = 0 {
        didSet { updateLayoutInternal() }
    }

    private var panVelocity: CGFloat = 0

    public func updateCurrent() {
        reels[reelsCount].update(data?.items[safe: currentItemIndex], at: currentIndex, isCurrent: true)
    }

    public func hint(count: Int = 0) {
        guard !isUserAttended, count < 2 else { return }
        animations.animate(delay: .custom(count == 0 ? 5.seconds : 1.seconds), time: .halfOfSecond, changes: { [self] in
            guard !isUserAttended else { return }
            panOffset = -80
        }) { [self] in
            guard !isUserAttended else { return }
            animations.animate(delay: .thirdOfSecond, time: .thirdOfSecond, changes: { [self] in
                guard !isUserAttended else { return }
                panOffset = 0
            }) { [self] in
                delay(.oneSecond) { [weak self] in
                    self?.hint(count: count + 1)
                }
            }
        }
    }

    public func next() {
        guard let data, currentItemIndex < data.items.count - 1 else { return }
        animations.animate { [self] in
            reels.append(reels.remove(at: 0))
            currentItemIndex += 1
            panOffset = 0
        }
    }

    public func prev() {
        guard currentItemIndex > 0 else { return }
        animations.animate { [self] in
            reels.insert(reels.removeLast(), at: 0)
            currentItemIndex -= 1
            panOffset = 0
        }
    }

    private func makeReels() {
        guard reels.isEmpty else { return }
        for _ in 0 ... reelsCount * 2 {
            let reel = ReelViewType()
            reels.append(reel)
            addContent(reel)
            reel.sendToBack()
        }
        gestures.onPan(.any, with: self) { [unowned self] pan in
            panHandle(pan: pan)
        }
    }

    override open func updateLayoutInternal() {
        makeReels()
        reels[reelsCount].layout.make { make in
            make.size = layout.size
            make.top = panOffset
            make.radius = min(16, abs(panOffset))
        }
        // TODO: Doublecheck - need update for transitions pins
        // reels[reelsCount].updateLayout()
        if reelsCount > 0 { for i in 1 ... reelsCount {
            reels[reelsCount - i].layout.make { make in
                make.size = layout.size
                make.top = panOffset - itemSpace - make.height
                make.radius = min(16, abs(panOffset))
            }
            reels[reelsCount + i].layout.make { make in
                make.size = layout.size
                make.top = panOffset + itemSpace + make.height
                make.radius = min(16, abs(panOffset))
            }
        }}
    }

    private func panHandle(pan: UIPanGestureRecognizer) {
        guard panEnabled else { return }
        switch pan.state {
            case .changed:
                panOffset = pan.translation(in: nil).y
                panVelocity = pan.velocity(in: nil).y
                didScroll.fire(panOffset)
                guard canEndPan() else {
                    panOffset *= 0.5
                    checkPanToPull()
                    return
                }
                if abs(panOffset) > panToSwipe {
                    willPanByVelocity = false
                }
                if willPanByVelocity, !didPanByVelocity,
                   panVelocity.sign == panOffset.sign,
                   abs(panVelocity) > velocityToSwipe {
                    didPanByVelocity = true
                }
                if didPanByVelocity,
                   panVelocity.sign != panOffset.sign {
                    didPanByVelocity = false
                }
            case .ended:
                panEnded()
            case .began:
                isUserAttended = true
            default:
                resetPanOffset()
        }
    }

    private func canEndPan() -> Bool {
        guard let data else { return false }
        if panOffset < 0, currentItemIndex < data.items.count - 1 { return true }
        if panOffset > 0, currentItemIndex > 0 { return true }
        return false
    }

    private func panEnded() {
        isPulledInCurrentPan = false
        willPanByVelocity = true
        panVelocity = 0

        defer {
            didPanByVelocity = false
            didScroll.fire(0)
        }

        guard canEndPan(),
              abs(panOffset) > panToSwipe || didPanByVelocity else {
            resetPanOffset()
            return
        }

        if panOffset < 0 { next() }
        if panOffset > 0 { prev() }
    }

    private func checkPanToPull() {
        guard !isPulledInCurrentPan else { return }

        if (panOffset < -panToPull) || (panVelocity < -velocityToSwipe) {
            isPulledInCurrentPan = true
            onPullUp.fire()
        }
        if panOffset > panToPull {
            isPulledInCurrentPan = true
            onPullDown.fire()
        }
    }

    private func resetPanOffset() {
        animations.animate { [self] in panOffset = 0 }
    }
}
