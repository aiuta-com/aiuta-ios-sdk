//
// Created by nGrey on 17.11.2022.
//

import Foundation

public typealias AsyncDelayCancelableToken = DispatchWorkItem

public class AutoCancellationToken {
    fileprivate var delayToken: AsyncDelayCancelableToken? = nil { willSet { cancel() } }
    fileprivate var timerToken: AsyncTimerCancelableToken? = nil { willSet { cancel() } }

    public func cancel() {
        delayToken?.cancel()
        timerToken?.cancel()
    }

    public init() {}
}

public func <<(token: AutoCancellationToken, delayToken: AsyncDelayCancelableToken) {
    token.delayToken = delayToken
}

public func <<(token: AutoCancellationToken, timerToken: AsyncTimerCancelableToken) {
    token.timerToken = timerToken
}
