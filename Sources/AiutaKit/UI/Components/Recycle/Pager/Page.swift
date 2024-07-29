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

import UIKit

@_spi(Aiuta) open class Page<DataType: Equatable>: Plane {
    public let onUpdate = Signal<Void>()

    public enum Position {
        case current, left, right

        var translate: CGFloat {
            switch self {
                case .current: return 0
                case .left: return -1
                case .right: return 1
            }
        }

        public var isSide: Bool {
            self != .current
        }
    }

    public private(set) var index: Int = 0
    public private(set) var position: Position = .current {
        didSet {
            guard oldValue != position else { return }
            update(position)
        }
    }

    public internal(set) var data: DataType? {
        didSet {
            view.isVisible = data.isSome
            guard data != oldValue else { return }
            update(data)
            onUpdate.fire()
        }
    }

    public internal(set) var isBeingDrag = false

    func setIndex(_ newIndex: Int, relativeTo currentIndex: Int) {
        index = newIndex
        if index == currentIndex {
            bringToFront()
            position = .current
        } else if index < currentIndex {
            position = .left
        } else {
            position = .right
        }
    }

    open func update(_ data: DataType?) { }
    open func update(_ position: Position) { }
}
