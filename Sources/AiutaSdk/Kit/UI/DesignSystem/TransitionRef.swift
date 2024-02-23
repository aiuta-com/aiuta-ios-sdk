//
// Created by nGrey on 04.02.2023.
//

import Foundation

protocol TransitionRef {
    var transitionId: String { get }
}

extension TransitionRef {
    var transitionId: String { String(reflecting: self) }
}
