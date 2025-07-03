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

@_spi(Aiuta) open class List: Plane {
    public let scrollView = HScroll()

    public var maxHeight: CGFloat?

    override func inspectChild(_ child: Any) -> Bool {
        if let scrollable = child as? ScrollWrapped {
            scrollView.addContent(scrollable.content)
            return true
        }
        return false
    }

    override func updateLayoutInternal() {
        scrollView.layout.make { make in
            make.size = layout.size
            if let maxHeight {
                make.height = min(maxHeight, make.height)
                make.centerY = 0
            }
        }
    }
}

final class IndirectList: HScroll {
    override func updateLayoutInternal() {
        layout.make { make in
            make.leftRight = 0
            make.height = subcontents.first?.layout.height ?? 0
        }
        super.updateLayoutInternal()
    }
}
