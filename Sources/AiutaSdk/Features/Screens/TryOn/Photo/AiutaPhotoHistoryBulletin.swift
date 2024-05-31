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

final class AiutaPhotoHistoryBulletin: PlainBulletin {
    let onSelectPack = Signal<Aiuta.UploadedImages>()
    let onDeletePack = Signal<Aiuta.UploadedImages>()

    var history: [[Aiuta.UploadedImage]] = [] {
        didSet {
            guard oldValue != history else { return }
            if history.isEmpty { dismiss() }
            gallery.removeAllContents()
            history.forEach { pack in
                gallery.addContent(HistoryCell()) { it, _ in
                    it.preview.inputs = .uploadedImages(pack)
                    it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                        onSelectPack.fire(pack)
                    }
                    it.deleteView.deleteButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                        onDeletePack.fire(pack)
                    }
                }
            }
            gallery.update()
        }
    }

    let title = Label { it, ds in
        it.font = ds.font.historyBulletinTitle
        it.text = L.uploadHistorySheetPreviously
    }

    let gallery = HScroll { it, _ in
        it.contentInset = .init(horizontal: 16)
        it.itemSpace = 8
    }

    let newPhotosButton = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.accent
        it.text = L.uploadHistorySheetUploadNewButton
    }

    override func updateLayout() {
        title.layout.make { make in
            make.leftRight = 16
        }

        gallery.layout.make { make in
            make.leftRight = 0
            make.top = title.layout.bottomPin + 16
            make.height = 255
        }

        newPhotosButton.layout.make { make in
            make.leftRight = 16
            make.top = gallery.layout.bottomPin + 24
            make.height = 50
            make.radius = 8
        }

        layout.make { make in
            make.height = newPhotosButton.layout.bottomPin + 12
        }
    }
}

extension AiutaPhotoHistoryBulletin {
    final class HistoryCell: PlainButton {
        let preview = AiutaCollageView { it, _ in
            it.counter.style = .small
        }

        let deleteView = DeleteView()

        override func setup() {
            view.borderWidth = 1
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 149
                make.height = 254
                make.radius = 16
            }

            preview.layout.make { make in
                make.inset = preview.count > 1 ? 8 : 0
                make.radius = preview.count > 1 ? 8 : 0
            }

            view.borderColor = preview.count > 1 ? ds.color.lightGray : .clear

            deleteView.layout.make { make in
                make.right = 9
                make.bottom = 9
            }
        }
    }

    final class DeleteView: Shadow {
        let deleteButton = ImageButton { it, ds in
            it.view.backgroundColor = ds.color.item
            it.image = ds.image.sdk(.aiutaTrash)
            it.tint = ds.color.red
        }

        override func setup() {
            shadowColor = .black
            shadowRadius = 4
            shadowOffset = .init(width: 0, height: 2)
            shadowOpacity = 0.2
        }

        override func updateLayout() {
            layout.make { make in
                make.size = .init(square: 32)
            }

            deleteButton.layout.make { make in
                make.circle = 32
            }
        }
    }
}
