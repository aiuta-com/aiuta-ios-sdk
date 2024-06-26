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

final class AiutaGenerationsHistoryView: Scroll {
    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let placholder = AiutaGenerationsHistoryPlaceholder()

    let swipeEdge = SwipeEdge()

    let navBar = AiutaNavBar { it, _ in
        it.header.logo.transitions.isReferenceActive = false
        it.header.logo.view.isVisible = false
        it.header.action.text = L.select
        it.header.title.text = L.history
    }

    @scrollable
    var history = AiutaGenerationsHistoryCell.ScrollRecycler()

    let selectionSnackbar = Snackbar<AiutaGenerationsHistorySnackbar>()

    override func setup() {
        blur.sendToBack()
    }

    override func updateLayout() {
        scrollView.contentInset = .init(top: navBar.layout.bottomPin, bottom: layout.safe.insets.bottom)

        scrollView.addContent(selectionSnackbar.placeholder)

        placholder.layout.make { make in
            make.center = .zero
        }

        blur.layout.make { make in
            make.top = navBar.layout.bottomPin
            make.leftRight = 0
            make.bottom = 0
        }
    }
}
