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

final class ProcessingView: Plane {
    let navBar = NavBar { it, ds in
        if ds.styles.preferCloseButtonOnTheRight {
            it.style = .actionTitleClose
        } else {
            it.style = .closeTitleAction
        }
        it.actionStyle = .icon(ds.icons.history24)
        it.title = ds.strings.tryOnPageTitle
    }

    let animator = LoadAnimator()

    let status = ProcessingStatus()

    let poweredBy = PoweredBy()

    let errorSnackbar = Snackbar<ErrorSnackbar>()

    func start() {
        errorSnackbar.isVisible = false
        animator.isAnimating = true
        status.text = nil
    }

    func stop() {
        status.text = nil
        animator.isAnimating = false
    }

    override func updateLayout() {
        animator.layout.make { make in
            make.leftRight = 50
            make.top = navBar.layout.bottomPin + 16
            make.bottom = layout.safe.insets.bottom + 169
            make.shape = ds.shapes.imageL
        }

        poweredBy.layout.make { make in
            make.centerX = 0
            make.bottom = layout.safe.insets.bottom + 16
        }

        status.layout.make { make in
            make.centerX = 0
            make.bottom = animator.layout.bottom + 24
        }
    }
}
