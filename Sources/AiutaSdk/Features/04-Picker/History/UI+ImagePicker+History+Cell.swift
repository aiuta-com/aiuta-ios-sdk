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

import AiutaCore
@_spi(Aiuta) import AiutaKit

extension PhotoHistoryBulletin {
    final class HistoryCell: PlainButton {
        let area = ErrorImage { it, ds in
            it.color = ds.colors.neutral
        }

        let preview = Image { it, _ in
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
        }

        let deleteView = ImageButton { it, ds in
            it.imageView.isAutoSize = false
            it.image = ds.icons.trash24
            it.tint = .white
        }

        let deleter = ActivityIndicator { it, ds in
            it.hasOverlay = true
        }

        var image: Aiuta.UserImage?

        var isDeleting = false {
            didSet {
                guard oldValue != isDeleting else { return }
                deleter.isAnimating = isDeleting
                deleteView.animations.visibleTo(!isDeleting)
            }
        }

        override func setup() {
            area.link(with: preview)
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 149
                make.height = 254
                make.shape = ds.shapes.imageM
            }

            area.layout.make { make in
                make.inset = 0
            }

            preview.layout.make { make in
                make.inset = 0
                make.shape = ds.shapes.imageM
            }

            deleteView.layout.make { make in
                make.square = 44
                make.right = -5
                make.bottom = -2
            }

            deleteView.imageView.layout.make { make in
                make.square = 24
                make.center = .zero
            }
        }
    }
}
