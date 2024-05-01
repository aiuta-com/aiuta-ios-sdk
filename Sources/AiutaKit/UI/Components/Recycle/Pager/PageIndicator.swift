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

@_spi(Aiuta) public final class PageIndicator: Content<PageIndicatorView> {
    public var drawer: AdvancedPageControlDraw {
        get { view.drawer }
        set { view.drawer = newValue }
    }

    public var count: Int {
        get { view.numberOfPages }
        set {
            guard newValue != count else { return }
            view.numberOfPages = newValue
            parent?.updateLayoutRecursive()
        }
    }

    public var index: Int = 0 {
        didSet { view.setPage(index) }
    }

    public var offset: CGFloat = 0 {
        didSet { view.setPageOffset(offset) }
    }

    public var contentSize: CGSize {
        CGSize(width: (drawer.size + 6) * CGFloat(count) + 6, height: drawer.size)
    }

    public convenience init(_ builder: (_ it: PageIndicator, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
