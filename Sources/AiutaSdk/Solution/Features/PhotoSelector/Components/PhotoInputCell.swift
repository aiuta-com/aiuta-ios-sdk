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

extension PhotoHistoryBulletin {
    final class HistoryCell: PlainButton {
        let preview = Image { it, ds in
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
            it.view.backgroundColor = ds.color.neutral
        }

        let deleteView = ImageButton { it, ds in
            it.image = ds.image.icon24(.trash)
            it.tint = .white
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 149
                make.height = 254
                make.radius = ds.dimensions.imagePreviewRadius
            }

            preview.layout.make { make in
                make.inset = 0
                make.radius = ds.dimensions.imagePreviewRadius
            }

            deleteView.layout.make { make in
                make.right = -2
                make.bottom = -2
            }
        }
    }
}
