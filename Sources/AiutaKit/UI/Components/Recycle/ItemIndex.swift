//
// Created by nGrey on 03.03.2023.
//

import Foundation

public struct ItemIndex: Equatable {
    public enum OrderType {
        case first, last, single, middle
    }

    public let item: Int
    public let count: Int

    public var isFirst: Bool {
        item == 0
    }

    public var isLast: Bool {
        item == count - 1
    }

    public var isSingle: Bool {
        count == 1
    }

    public var order: OrderType {
        if isSingle { return .single }
        if isFirst { return .first }
        if isLast { return .last }
        return .middle
    }

    public init(_ item: Int, of count: Int) {
        self.item = item
        self.count = count
    }
}
