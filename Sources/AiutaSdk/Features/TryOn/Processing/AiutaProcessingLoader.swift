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

import AiutaKit
import UIKit

final class AiutaProcessingLoader: Plane {
    let preview = AiutaPreviewWithLoader()
    let status = AiutaPreviewStatus()

    override func setup() {
        view.backgroundColor = ds.color.item
    }

    override func updateLayout() {
        let s = layout.boundary.width / 350
        
        layout.make { make in
            make.width = 269 * s
            make.height = 130 + 349 * s
            make.radius = 24
        }

        preview.layout.make { make in
            make.width = 195 * s
            make.height = 349 * s
            make.radius = 8
            make.top = 37
            make.centerX = 0
        }

        status.layout.make { make in
            make.top = preview.layout.bottomPin + 33
        }
    }
}

final class AiutaPreviewWithLoader: Plane {
    let imageView = Image { it, _ in
        it.contentMode = .scaleAspectFill
        it.isAutoSize = false
        it.view.isHiRes = true
    }

    let loader = Image { it, ds in
        it.image = ds.image.sdk(.aiutaLoader)
        it.view.isVisible = false
    }

    private var isLoaderOnTop = false {
        didSet { updateLayout() }
    }

    override func updateLayout() {
        imageView.layout.make { make in
            make.size = layout.bounds.size
            make.radius = view.cornerRadius
        }

        loader.layout.make { make in
            make.width = layout.bounds.width
            make.centerX = 0
            if isLoaderOnTop {
                make.bottom = layout.height
            } else {
                make.top = layout.height
            }
        }

        if !loader.view.isVisible {
            loader.view.isVisible = true
            animateLoader()
        }
    }

    private func animateLoader() {
        isLoaderOnTop = false
        animations.animate(delay: .halfOfSecond, time: .custom(4.seconds)) { [weak self] in
            self?.isLoaderOnTop = true
        } complete: { [weak self] in
            self?.animateLoader()
        }
    }
}

final class AiutaPreviewStatus: Plane {
    let spinner = Spinner()

    let label = Label { it, ds in
        it.font = ds.font.secondary
        it.text = "Uploading image"
    }

    override func updateLayout() {
        layout.make { make in
            make.height = spinner.layout.height
        }

        spinner.layout.make { make in
            make.centerY = 0
        }

        label.layout.make { make in
            make.left = spinner.layout.rightPin + 8
            make.centerY = -2
        }

        layout.make { make in
            make.width = label.layout.rightPin
            make.centerX = 0
        }
    }
}
