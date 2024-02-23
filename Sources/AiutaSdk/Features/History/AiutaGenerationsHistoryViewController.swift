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


import Resolver
import UIKit

final class AiutaGenerationsHistoryViewController: ViewController<AiutaGenerationsHistoryView> {
    @Injected private var model: AiutaSdkModel

    override func prepare() {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left),
                                            dismissing: .pull(direction: .right))
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.navBar.header.action.onTouchUpInside.subscribe(with: self) { [unowned self] in
            isEditMode.toggle()
        }

        ui.selectionSnackbar.bar.cancelButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            isEditMode = false
        }

        ui.selectionSnackbar.bar.gestures.onSwipe(.down, with: self) { [unowned self] _ in
            isEditMode = false
        }

        ui.selectionSnackbar.bar.toggleSeletionButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if isSelectedAll { selection.removeAll() }
            else { selection = model.generationHistory }
        }

        ui.selectionSnackbar.bar.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard !selection.isEmpty else { return }
            shareSelection()
        }

        ui.selectionSnackbar.bar.deleteButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard !selection.isEmpty else { return }
            deleteSelection()
        }

        ui.history.onUpdateItem.subscribe(with: self) { [unowned self] cell in
            guard let image = cell.data else {
                cell.isSelectable = false
                return
            }
            cell.isSelectable = isEditMode
            cell.isSelected = isEditMode && selection.contains(image)
        }

        ui.history.onTapItem.subscribe(with: self) { [unowned self] cell in
            if isEditMode { toggleSelection(cell) }
            else { enterFullscreen(cell) }
        }

        ui.history.data = PartialDataProvider(model.generationHistory)

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }

    private var isEditMode = false {
        didSet {
            guard oldValue != isEditMode else { return }
            ui.selectionSnackbar.isVisible = isEditMode
            ui.history.updateItems()
            if !isEditMode { selection.removeAll() }
        }
    }

    private var selection = [Aiuta.GeneratedImage]() {
        didSet {
            guard oldValue != selection else { return }
            ui.history.updateItems()
            updateSelection()
        }
    }

    var isSelectedAll: Bool {
        !selection.isEmpty && (selection.count == model.generationHistory.count)
    }

    func toggleSelection(_ cell: AiutaGenerationsHistoryCell) {
        guard let image = cell.data else { return }
        if selection.contains(image) {
            selection.removeAll(where: { $0 == image })
        } else {
            selection.append(image)
        }
    }

    func updateSelection() {
        ui.selectionSnackbar.bar.deleteButton.isEnabled = !selection.isEmpty
        ui.selectionSnackbar.bar.shareButton.isEnabled = !selection.isEmpty

        ui.selectionSnackbar.bar.toggleSeletionButton.text = isSelectedAll ? "Select none" : "Select all"
        ui.selectionSnackbar.bar.view.layoutSubviews()
    }

    func deleteSelection() {
        model.generationHistory.removeAll { item in
            selection.contains(item)
        }
        isEditMode = false
        if model.generationHistory.isEmpty {
            dismiss()
        }
    }

    func shareSelection() {
        let imagesToShare: [UIImage] = ui.history.activeCells.compactMap { cell in
            cell.generagedImage.image
        }
        guard !imagesToShare.isEmpty else { return }
        share(images: imagesToShare)
        isEditMode = false
    }

    func enterFullscreen(_ cell: AiutaGenerationsHistoryCell) {
        present(AiutaGeneratedGalleryViewController(ui.history.data, start: cell.index.item))
    }
}
