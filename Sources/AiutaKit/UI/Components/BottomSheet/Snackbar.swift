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

@_spi(Aiuta) public final class Snackbar<Body: Plane>: Plane {
    public let bar = Body()

    @scrollable
    public var placeholder = ScrollSpacer()

    public var isVisible = false {
        didSet {
            guard oldValue != isVisible else { return }
            view.isUserInteractionEnabled = isVisible
            placeholder.isVisible = isVisible
            animations.updateLayout()
        }
    }

    override func setupInternal() {
        view.isUserInteractionEnabled = isVisible
    }
    
    public var bottomInset: CGFloat = 0

    override func updateLayoutInternal() {
        placeholder.height = bar.layout.height + 8
        
        layout.make { make in
            make.height = bar.layout.height
            make.width = min(600, layout.boundary.width - 16)
            make.centerX = 0
            make.bottom = isVisible ? (bottomInset > 0 ? bottomInset : layout.safe.insets.bottom) + 8 : -make.height
        }

        bar.layout.make { make in
            make.size = layout.size
            make.top = 0
        }
    }

    public final class ScrollSpacer: Plane {
        var isVisible = false {
            didSet {
                guard oldValue != isVisible else { return }
                animations.animate { [self] in
                    parentScroll?.update()
                }
            }
        }

        var height: CGFloat = 0 {
            didSet {
                guard oldValue != height else { return }
                parentScroll?.update()
            }
        }

        override func updateLayoutInternal() {
            layout.make { make in
                make.height = isVisible ? height : 0
            }
        }

        var parentScroll: VScroll? {
            firstParentOfType()
        }
    }
}
