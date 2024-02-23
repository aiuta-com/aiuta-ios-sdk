//
// Created by nGrey on 03.03.2023.
//

import Foundation

struct ItemIndex: Equatable {
    enum OrderType {
        case first, last, single, middle
    }

    let item: Int
    let count: Int

    var isFirst: Bool {
        item == 0
    }

    var isLast: Bool {
        item == count - 1
    }

    var isSingle: Bool {
        count == 1
    }

    var order: OrderType {
        if isSingle { return .single }
        if isFirst { return .first }
        if isLast { return .last }
        return .middle
    }

    init(_ item: Int, of count: Int) {
        self.item = item
        self.count = count
    }
}
