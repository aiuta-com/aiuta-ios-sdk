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

@_spi(Aiuta) public enum ThreadQoS {
    case main, mainAsync
    case user, medium, background

    fileprivate var dispatchQueue: DispatchQueue {
        switch self {
            case .main: return DispatchQueue.main
            case .mainAsync: return DispatchQueue.main
            case .user: return DispatchQueue.global(qos: .userInteractive)
            case .medium: return DispatchQueue.global(qos: .userInitiated)
            case .background: return DispatchQueue.global(qos: .background)
        }
    }
}

@_spi(Aiuta) public func dispatch(_ ref: ThreadQoS, execute work: @escaping @convention(block) () -> Void) {
    if (ref == .main) && Thread.isMainThread {
        work()
    } else {
        ref.dispatchQueue.async(execute: work)
    }
}
