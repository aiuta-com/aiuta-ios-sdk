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

@_spi(Aiuta) open class Recycle<RecycleDataType>: PlainButton {
    internal let didInvalidate = Signal<RecycleDataType>()

    internal var isVisited = false
    internal var isUsed = false {
        didSet {
            view.isVisible = isUsed
            view.isUserInteractionEnabled = isUsed
        }
    }

    public internal(set) var data: RecycleDataType?
    public internal(set) var index: ItemIndex = .init(-1, of: 0)

    open func update(_ data: RecycleDataType?, at index: ItemIndex) {}

    public func invalidate() {
        guard let data else { return }
        didInvalidate.fire(data)
    }
}
