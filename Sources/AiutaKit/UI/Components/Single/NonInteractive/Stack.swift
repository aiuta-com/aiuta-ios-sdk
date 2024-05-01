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

@_spi(Aiuta) open class Stack: Content<PlainView> {
    public convenience init(_ builder: (_ it: Stack, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    override func updateLayoutInternal() {
        let itemWidth = layout.width / CGFloat(subcontents.count)
        subcontents.indexed.forEach { i, sub in
            sub.layout.make { make in
                make.width = itemWidth
                make.height = layout.height
                make.left = CGFloat(i) * itemWidth
            }
        }
    }
}

@_spi(Aiuta) public extension UIStackView {
    func arrange(_ content: ContentBase) {
        addArrangedSubview(content.container)
    }

    func addSpace(_ value: CGFloat, after content: ContentBase) {
        setCustomSpacing(value, after: content.container)
    }
}
