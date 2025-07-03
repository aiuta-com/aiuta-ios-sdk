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

@_spi(Aiuta) open class Scroll: Plane {
    public let scrollView = VScroll()

    public var maxWidth: CGFloat?

    override func inspectChild(_ child: Any) -> Bool {
        if let scrollable = child as? ScrollWrapped {
            scrollView.addContent(scrollable.content)
            return true
        }
        if let list = child as? ListWrapped {
            let indirectList = IndirectList()
            indirectList.addContent(list.content)
            scrollView.addContent(indirectList)
            return true
        }
        return false
    }

    override func updateLayoutInternal() {
        scrollView.layout.make { make in
            make.size = layout.size
            if let maxWidth {
                make.width = min(maxWidth, make.width)
                make.centerX = 0
            }
        }
    }
}
