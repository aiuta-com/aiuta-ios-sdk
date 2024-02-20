//
// Created by nGrey on 02.02.2023.
//

import Foundation

public extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array {
    var second: Element? {
        self[safe: 1]
    }
}
