//
// Created by nGrey on 03.11.2022.
//

import Foundation

typealias AsyncCallback = () -> Void

private let globalAsyncTimer = AsyncTimer()

@discardableResult
func delay(_ time: AsyncDelayTime, execute work: AsyncCallback?) -> AsyncDelayCancelableToken {
    guard let work else { return dumbWorkToken }
    assert(time < .inoperable)
    let workItem = AsyncDelayCancelableToken(block: work)
    DispatchQueue.main.asyncAfter(deadline: time.dispatchTime, execute: workItem)
    return workItem
}

@discardableResult
func interval(_ time: AsyncDelayTime, execute work: @escaping AsyncCallback) -> AsyncTimerCancelableToken {
    globalAsyncTimer.every(time, execute: work)
}

private let dumbWorkToken = AsyncDelayCancelableToken(block: {})
