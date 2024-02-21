//
//  Created by nGrey on 15.05.2023.
//

import Foundation

@available(iOS 13.0.0, *)
public func asleep(_ delay: AsyncDelayTime) async {
    let duration = UInt64(delay.seconds * 1000000000)
    try? await Task.sleep(nanoseconds: duration)
}
