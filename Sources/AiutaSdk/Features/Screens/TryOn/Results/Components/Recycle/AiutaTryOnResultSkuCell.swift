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

final class AiutaTryOnResultSkuCell: AiutaGalleryItemView<String> {
    final class ContentView: Plane {
        let skuImage = Image { it, _ in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
        }

        let swipeForMore = AiutaTryOnMoreFooterView()

        override func updateLayout() {
            skuImage.layout.make { make in
                make.size = layout.size
                make.radius = 24
            }
        }
    }

    let contentView = ContentView()

    override func update(_ data: String?) {
        contentView.skuImage.source = data
        contentView.view.isVisible = data.isSome
    }

    override func setIndex(_ newIndex: Int, relativeTo currentIndex: Int) {
        super.setIndex(newIndex, relativeTo: currentIndex)
        contentView.swipeForMore.canBeVisible = newIndex == currentIndex
    }

    override func updateLayout() {
        contentView.layout.make { make in
            make.leftRight = 4
            make.top = 0
            make.bottom = 0
            make.radius = 24
        }
    }
}
