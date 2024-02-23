//
// Created by nGrey on 19.02.2023.
//

import Foundation

enum ThreadQoS {
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

func dispatch(_ ref: ThreadQoS, execute work: @escaping @convention(block) () -> Void) {
    if (ref == .main) && Thread.isMainThread {
        work()
    } else {
        ref.dispatchQueue.async(execute: work)
    }
}
