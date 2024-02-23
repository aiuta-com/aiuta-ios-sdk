//
// Created by nGrey on 02.02.2023.
//

import Foundation

extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    var second: Element? {
        self[safe: 1]
    }
}
