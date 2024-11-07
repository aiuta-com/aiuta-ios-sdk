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
    let onSelect = Signal<Aiuta.Image>()
    let onDelete = Signal<Aiuta.Image>()

    var history: DataProvider<Aiuta.Image>? {
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

    var deleting: DataProvider<Aiuta.Image>? {
        didSet {
            oldValue?.onUpdate.cancelSubscription(for: self)
            updateDeleting()
            guard let deleting else { return }
            deleting.onUpdate.subscribe(with: self) { [unowned self] in
                updateDeleting()
            }
        }
    }

    private func updateDeleting() {
        cells.forEach { cell in
            guard let image = cell.image else { return }
            cell.isDeleting = deleting?.items.contains(image) ?? false
        }
    }

    let title = Label { it, ds in
        it.font = ds.font.titleM
        it.color = ds.color.primary
        it.text = L.uploadsHistorySheetPreviously
    }

    let gallery = HScroll { it, _ in
        it.contentInset = .init(horizontal: 16)
        it.itemSpace = 8
    }

    let newPhotosButton = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.brand
        it.label.color = ds.color.onDark
        it.text = L.uploadsHistorySheetUploadNewButton
    }

    let errorSnackbar = Snackbar<ErrorSnackbar>()

    private var cells: [HistoryCell] {
        gallery.findChildren()
    }

    private func buildHistory() {
        if history?.isEmpty == true { dismiss() }
        gallery.removeAllContents()
        history?.items.forEach { img in
            gallery.addContent(HistoryCell()) { it, _ in
                it.image = img
                it.preview.source = img
                it.onTouchUpInside.subscribe(with: self) { [unowned self, weak it] in
                    guard it?.isDeleting == false else { return }
                    onSelect.fire(img)
                }
                it.deleteView.onTouchUpInside.subscribe(with: self) { [unowned self] in
                    onDelete.fire(img)
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
