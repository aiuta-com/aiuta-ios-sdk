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

final class PhotoHistoryBulletin: PlainBulletin {
    let onSelect = Signal<Aiuta.UploadedImage>()
    let onDelete = Signal<Aiuta.UploadedImage>()

    var history: DataProvider<Aiuta.UploadedImage>? {
        didSet {
            oldValue?.onUpdate.cancelSubscription(for: self)
            guard let history else {
                gallery.removeAllContents()
                return
            }
            history.onUpdate.subscribe(with: self) { [unowned self] in
                buildHistory()
            }
            buildHistory()
        }
    }

    let title = Label { it, ds in
        it.font = ds.font.titleM
        it.color = ds.color.primary
        it.text = L.uploadHistorySheetPreviously
    }

    let gallery = HScroll { it, _ in
        it.contentInset = .init(horizontal: 16)
        it.itemSpace = 8
    }

    let newPhotosButton = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.brand
        it.label.color = ds.color.onDark
        it.text = L.uploadHistorySheetUploadNewButton
    }

    private func buildHistory() {
        if history?.isEmpty == true { dismiss() }
        gallery.removeAllContents()
        history?.items.forEach { pack in
            gallery.addContent(HistoryCell()) { it, _ in
                it.preview.source = pack
                it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                    onSelect.fire(pack)
                }
                it.deleteView.onTouchUpInside.subscribe(with: self) { [unowned self] in
                    onDelete.fire(pack)
                }
            }
        }
        gallery.update()
    }

    override func setup() {
        maxWidth = 600
        strokeWidth = ds.dimensions.grabberWidth
        strokeOffset = ds.dimensions.grabberOffset
        cornerRadius = ds.dimensions.bottomSheetRadius
        view.backgroundColor = ds.color.ground
    }

    override func updateLayout() {
        title.layout.make { make in
            make.leftRight = 16
            make.top = 6
        }

        gallery.layout.make { make in
            make.leftRight = 0
            make.top = title.layout.bottomPin + 24
            make.height = 255
        }

        newPhotosButton.layout.make { make in
            make.leftRight = 16
            make.top = gallery.layout.bottomPin + 26
            make.height = 50
            make.radius = ds.dimensions.buttonLargeRadius
        }

        layout.make { make in
            make.height = newPhotosButton.layout.bottomPin + 12
        }
    }
}
