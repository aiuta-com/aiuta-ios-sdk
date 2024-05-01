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

import Foundation

@_spi(Aiuta) public class AsyncTimer {
    private var now: TimeInterval { Date().timeIntervalSince1970 }
    private var loopTime: TimeInterval { now - lastLoopTime }
    private lazy var lastLoopTime: TimeInterval = now

    private lazy var items = AsyncTimerItemsStorage(weakTimer: self)
    private lazy var runner = AsyncTimerRunner { [weak self] in
        guard let self = self else { return .inoperable }
        self.items.reduce(self.loopTime)
        self.lastLoopTime = self.now
        return self.items.desiredTime(self.loopTime)
    }

    @discardableResult
    public func every(_ time: AsyncDelayTime, owner: AnyObject? = nil, execute work: @escaping AsyncCallback) -> AsyncTimerCancelableToken {
        let token = items.add(work, time: time, owner: owner)
        if !runner.isRunning { lastLoopTime = now }
        runner.run(items.desiredTime(loopTime))
        return token
    }

    public func cancelAll(ownedBy owner: AnyObject) {
        items.remove(owner: owner)
        runner.run(items.desiredTime(loopTime))
    }
}

@_spi(Aiuta) public class AsyncTimerCancelableToken {
    private weak var item: AsyncTimerItem?
    private var isCanceled = false

    fileprivate init(item: AsyncTimerItem) {
        self.item = item
    }

    public func cancel() {
        if isCanceled { return }
        item?.remove(token: self)
        isCanceled = true
    }
}

private class AsyncTimerItemsStorage {
    private var items = [AsyncDelayTime: AsyncTimerItem]()
    private weak var timer: AsyncTimer?

    init(weakTimer: AsyncTimer) {
        timer = weakTimer
    }

    func add(_ work: @escaping AsyncCallback, time: AsyncDelayTime, owner: AnyObject?) -> AsyncTimerCancelableToken {
        let item = items[time] ?? AsyncTimerItem(timer: timer, period: time)
        items[time] = item
        return item.add(work, owner: owner)
    }

    func reduce(_ time: TimeInterval) {
        items.forEach { $1.reduce(time) }
    }

    func remove(owner: AnyObject) {
        items.forEach { $1.remove(owner: owner) }
    }

    func desiredTime(_ remindTime: TimeInterval) -> AsyncDelayTime {
        var time: AsyncDelayTime = .inoperable
        items.forEach { time = min(time, $1.desiredTime(remindTime)) }
        return time
    }
}

private class AsyncTimerItem {
    private let period: AsyncDelayTime
    private var remain: TimeInterval
    private var callbacks = [AsyncTimerCallback]()
    private weak var timer: AsyncTimer?

    init(timer: AsyncTimer?, period: AsyncDelayTime) {
        self.timer = timer
        self.period = period
        remain = self.period.seconds
    }

    func desiredTime(_ remindTime: TimeInterval) -> AsyncDelayTime {
        callbacks.isEmpty ? .inoperable : AsyncDelayTime(remain - remindTime)
    }

    func reduce(_ time: TimeInterval) {
        remain -= time
        if remain < 0 { callbacks.forEach { $0.work() } }
        while remain < 0, period > .instant { remain += period.seconds }
        if remain < 0 { remain = 0 }
    }

    func add(_ work: @escaping AsyncCallback, owner: AnyObject?) -> AsyncTimerCancelableToken {
        let cancelableToken = AsyncTimerCancelableToken(item: self)
        callbacks.append(AsyncTimerCallback(token: cancelableToken, owner: owner, work: work))
        return cancelableToken
    }

    func remove(token: AsyncTimerCancelableToken) {
        callbacks.removeAll { $0.token === token }
        timer?.cancelAll(ownedBy: token)
    }

    func remove(owner: AnyObject) {
        callbacks.removeAll { $0.owner === owner }
        if callbacks.isEmpty { remain = period.seconds }
    }
}

private struct AsyncTimerCallback {
    var token: AsyncTimerCancelableToken
    var owner: AnyObject?
    var work: AsyncCallback
}

private class AsyncTimerRunner {
    private(set) var isRunning = false

    private let work: () -> AsyncDelayTime
    private let token = AutoCancellationToken()

    init(_ work: @escaping () -> AsyncDelayTime) {
        self.work = work
    }

    func run(_ time: AsyncDelayTime) {
        if time >= .inoperable {
            isRunning = false
            token.cancel()
            return
        }

        isRunning = true
        token << delay(time) { [weak self] in
            guard let self = self else { return }
            self.run(self.work())
        }
    }
}
