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



final class AiutaGenerationsHistoryCell: Recycle<Aiuta.GeneratedImage> {
    final class ScrollRecycler: Recycler<AiutaGenerationsHistoryCell, Aiuta.GeneratedImage> {
        override func setup() {
            contentInsets = .init(inset: 8)
            contentSpace = .init(square: 8)
            contentFraction = .init(width: .fractionMaxWidth(1 / 3, 140), height: .widthMultiplyer(3 / 2))
        }
    }

    let generagedImage = Image { it, _ in
        it.contentMode = .scaleAspectFill
        it.isAutoSize = false
        it.view.backgroundColor = .white

        it.transitions.make { make in
            make.noFade()
        }
    }

    let selection = Image { it, ds in
        it.image = ds.image.sdk(.aiutaSelection)
        it.view.isVisible = false
    }

    let selected = Image { it, ds in
        it.image = ds.image.sdk(.aiutaSelected)
        it.view.isVisible = false
    }

    var isSelectable = false {
        didSet {
            guard oldValue != isSelectable else { return }
            selection.animations.visibleTo(isSelectable)
            if !isSelectable { isSelected = false }
        }
    }

    var isSelected = false {
        didSet {
            guard oldValue != isSelected else { return }
            selection.animations.visibleTo(isSelectable)
            selected.animations.visibleTo(isSelectable && isSelected)
        }
    }

    override func updateLayout() {
        generagedImage.layout.make { make in
            make.size = layout.size
            make.radius = 16
        }

        selection.layout.make { make in
            make.top = 8
            make.right = 8
        }

        selected.layout.make { make in
            make.top = 8
            make.right = 8
        }
    }

    override func update(_ data: Aiuta.GeneratedImage?, at index: ItemIndex) {
        generagedImage.imageUrl = data?.imageUrl
        generagedImage.transitions.reference = data
    }
}
