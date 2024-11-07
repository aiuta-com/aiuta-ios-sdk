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

final class HistoryView: Scroll {
    let blur = Blur { it, ds in
        it.style = ds.color.blur
    }

    let stroke = Stroke { it, ds in
        it.color = ds.color.ground
    }

    let navBar = NavBar { it, _ in
        it.style = .backTitleAction
        it.actionStyle = .label(L.appBarSelect)
        it.title = L.appBarHistory
    }

    @scrollable
    var history = HistoryCell.ScrollRecycler()

    let selectionSnackbar = Snackbar<HistorySnack>()
    let errorSnackbar = Snackbar<ErrorSnackbar>()

    override func setup() {
        scrollView.didScroll.subscribe(with: self) { [unowned self] scroll in
            stroke.animations.visibleTo(scroll.isAtTop, showTime: .sixthOfSecond, hideTime: .sixthOfSecond)
        }
        scrollView.addContent(selectionSnackbar.placeholder)
        scrollView.addContent(errorSnackbar.placeholder)
    }

    override func updateLayout() {
        blur.layout.make { make in
            make.top = 0
            make.leftRight = 0
            make.bottom = navBar.layout.bottom
        }

        stroke.layout.make { make in
            make.frame = blur.layout.frame
        }

        scrollView.contentInset = .init(top: navBar.layout.bottomPin, bottom: layout.safe.insets.bottom)
    }
}
