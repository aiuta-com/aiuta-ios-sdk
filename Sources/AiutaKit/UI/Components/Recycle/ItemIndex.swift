// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

@_spi(Aiuta) public struct ItemIndex: Equatable {
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
