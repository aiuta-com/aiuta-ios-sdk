//
// Created by nGrey on 04.02.2023.
//

import Foundation

public protocol TransitionRef {
    var transitionId: String { get }
}

public extension TransitionRef {
    var transitionId: String { String(reflecting: self) }
}
