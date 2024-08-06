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

final class UnfairLock {
    private let unfairLock: os_unfair_lock_t
    private let unfairValue: os_unfair_lock_s

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairValue = .init()
        unfairLock.initialize(to: unfairValue)
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    func synchronize(_ work: () -> Void) {
        lock()
        defer { unlock() }
        work()
    }
}

extension UnfairLock: NSLocking {
    func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    func tryLock() -> Bool {
        os_unfair_lock_trylock(unfairLock)
    }

    func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
