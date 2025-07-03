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

@_spi(Aiuta) import AiutaKit
import UIKit

extension Sdk.UI {
    final class TryOn: Plane {
        let navBar = NavBar { it, ds in
            if ds.styles.preferCloseButtonOnTheRight {
                it.style = .actionTitleClose
            } else {
                it.style = .closeTitleAction
            }
            it.actionStyle = .icon(ds.icons.history24)
            it.title = ds.strings.tryOnPageTitle
        }
        
        let emptyState = EmptyState()
        let photoState = PhotoState()
        
        @bulletin
        var skuBulletin = ProductBulletin { it, ds in
            it.wishButton.view.isVisible = ds.features.wishlist.isEnabled
        }
        
        override func updateLayout() {
            [emptyState, photoState].forEach { state in
                state.layout.make { make in
                    make.top = navBar.layout.bottomPin
                    make.leftRight = 0
                    make.bottom = 0
                }
            }
        }
    }
}
