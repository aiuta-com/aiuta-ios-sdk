//
// Created by nGrey on 17.11.2022.
//

import Foundation

typealias AsyncDelayCancelableToken = DispatchWorkItem

class AutoCancellationToken {
    fileprivate var delayToken: AsyncDelayCancelableToken? = nil { willSet { cancel() } }
    fileprivate var timerToken: AsyncTimerCancelableToken? = nil { willSet { cancel() } }

    func cancel() {
        delayToken?.cancel()
        timerToken?.cancel()
    }

    init() {}
}

func <<(token: AutoCancellationToken, delayToken: AsyncDelayCancelableToken) {
    token.delayToken = delayToken
}

func <<(token: AutoCancellationToken, timerToken: AsyncTimerCancelableToken) {
    token.timerToken = timerToken
}
