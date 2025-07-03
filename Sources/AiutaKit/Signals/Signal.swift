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

@_spi(Aiuta)
public final class Signal<T>: @unchecked Sendable {
    @usableFromInline typealias SendableSyncCallback = @Sendable (T) -> Void

    public var observers: [AnyObject] {
        lock.lock(); defer { lock.unlock() }
        return signalListeners.compactMap { $0.observer }
    }

    public var retainLastData: Bool = false {
        didSet { if !retainLastData { lastDataFired = nil } }
    }

    public private(set) var fireCount: Int = 0
    public private(set) var lastDataFired: T?

    private var signalListeners = [SignalSubscription<T>]()
    private let lock = UnfairLock()

    public init(retainLastData: Bool = false) {
        self.retainLastData = retainLastData
    }

    private func flushCancelledListeners() {
        signalListeners.removeAll { $0.observer == nil }
    }
}

@_spi(Aiuta)
public extension Signal {
    typealias SyncCallback = (T) -> Void

    func subscribe(with observer: AnyObject, callback: @escaping SyncCallback) {
        createSubscribtion(with: observer, callback: callback)
    }

    func subscribeOnce(with observer: AnyObject, callback: @escaping SyncCallback) {
        let sub = createSubscribtion(with: observer, callback: callback)
        sub.once = true
    }

    func subscribePast(with observer: AnyObject, callback: @escaping SyncCallback) {
        assert(retainLastData, "retainLastData must be enabled for subscribePast")
        let sub = createSubscribtion(with: observer, callback: callback)
        if let data = lastDataFired { sub.dispatchData(data) }
    }

    func subscribePastOnce(with observer: AnyObject, callback: @escaping SyncCallback) {
        assert(retainLastData, "retainLastData must be enabled for subscribePastOnce")
        let sub = createSubscribtion(with: observer, callback: callback)
        if let data = lastDataFired {
            sub.dispatchData(data)
            sub.cancel()
        } else {
            sub.once = true
        }
    }

    @discardableResult
    private func createSubscribtion(with observer: AnyObject, callback: @escaping SyncCallback) -> SignalSubscription<T> {
        let boxed: SendableSyncCallback = { value in callback(value) }
        lock.lock(); defer { lock.unlock() }
        flushCancelledListeners()
        let sub = SignalSubscription(observer: observer, callback: boxed)
        signalListeners.append(sub)
        return sub
    }
}

@_spi(Aiuta)
public extension Signal {
    typealias AsyncCallback = @MainActor @Sendable (T) async -> Void

    func task(with observer: AnyObject, callback: @escaping AsyncCallback) {
        createSubscribtion(with: observer, task: callback)
    }

    func taskOnce(with observer: AnyObject, callback: @escaping AsyncCallback) {
        let sub = createSubscribtion(with: observer, task: callback)
        sub.once = true
    }

    func taskPast(with observer: AnyObject, callback: @escaping AsyncCallback) {
        assert(retainLastData, "retainLastData must be enabled for taskPast")
        let sub = createSubscribtion(with: observer, task: callback)
        if let data = lastDataFired { sub.dispatchData(data) }
    }

    func taskPastOnce(with observer: AnyObject, callback: @escaping AsyncCallback) {
        assert(retainLastData, "retainLastData must be enabled for taskPastOnce")
        let sub = createSubscribtion(with: observer, task: callback)
        if let data = lastDataFired {
            sub.dispatchData(data)
            sub.cancel()
        } else {
            sub.once = true
        }
    }

    @discardableResult
    private func createSubscribtion(with observer: AnyObject, task: @escaping AsyncCallback) -> SignalSubscription<T> {
        lock.lock(); defer { lock.unlock() }
        flushCancelledListeners()
        let sub = SignalSubscription(observer: observer, task: task)
        signalListeners.append(sub)
        return sub
    }
}

@_spi(Aiuta)
public extension Signal {
    func fire(_ data: T) {
        lock.lock()
        fireCount += 1
        if retainLastData { lastDataFired = data }
        flushCancelledListeners()
        let listeners = signalListeners
        lock.unlock()

        for sub in listeners {
            sub.dispatchData(data)
        }
    }

    func tryFire(_ data: T?) {
        if let data { fire(data) }
    }
}

@_spi(Aiuta)
public extension Signal where T == Void {
    func fire() { fire(()) }
}

@_spi(Aiuta)
public extension Signal {
    func cancelSubscription(for observer: AnyObject) {
        lock.lock()
        signalListeners.removeAll { $0.observer === observer }
        lock.unlock()
    }

    func cancelAllSubscriptions() {
        lock.lock()
        signalListeners.removeAll()
        lock.unlock()
    }

    func clearLastData() {
        lastDataFired = nil
    }
}

private final class SignalSubscription<T>: @unchecked Sendable {
    @usableFromInline typealias AsyncCallback = @MainActor @Sendable (T) async -> Void
    @usableFromInline typealias SyncCallback = @Sendable (T) -> Void

    fileprivate weak var observer: AnyObject?
    fileprivate var callback: SyncCallback?
    fileprivate var task: AsyncCallback?
    fileprivate var once = false

    fileprivate init(observer: AnyObject, callback: @escaping SyncCallback) {
        self.observer = observer
        self.callback = callback
    }

    fileprivate init(observer: AnyObject, task: @escaping AsyncCallback) {
        self.observer = observer
        self.task = task
    }

    func cancel() {
        observer = nil
    }

    func dispatchData(_ data: T) {
        if #available(iOS 13.0, *), task.isSome {
            Task { @MainActor [observer] in await dispatchAsync(data, with: observer) }
        } else {
            dispatchSync(data)
        }
    }

    private func dispatchSync(_ data: T) {
        dispatch(.main) { [self] in
            guard observer != nil else { return }
            if once { observer = nil }
            callback?(data)
        }
    }

    @available(iOS 13.0, *)
    @MainActor private func dispatchAsync(_ data: T, with observer: AnyObject?) async {
        guard observer != nil else { return }
        if once { self.observer = nil }
        await task?(data)
    }
}
