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

@available(iOS 13.0.0, *)
final class AiutaGenerationsHistoryViewController: ViewController<AiutaGenerationsHistoryView> {
    @injected private var model: AiutaSdkModel
    @injected private var watermarker: Watermarker
    @injected private var tracker: AnalyticTracker

    override func prepare() {
        hero.isEnabled = true
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
            Task { await shareSelection() }
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

        model.onChangeHistory.subscribe(with: self) { [unowned self] _ in
            onUpdateHistory()
        }

        onUpdateHistory()

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }

    override func whenAttached() {
        tracker.track(.history(.open))
        model.delegate?.aiuta(eventOccurred: .historyScreenOpened)
    }

    func onUpdateHistory() {
        let history = model.generationHistory
        ui.placholder.view.isVisible = history.isEmpty
        ui.navBar.isActionAvailable = !history.isEmpty
        ui.history.data = PartialDataProvider(history)
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

    func shareSelection() async {
        tracker.track(.share(.start(origin: .history, count: selection.count, hasText: false)))
        let imagesToShare: [UIImage] = await selection.concurrentCompactMap { [watermarker] in
            guard let image = try? await $0.fetch() else { return nil }
            return watermarker.watermark(image)
        }
        guard !imagesToShare.isEmpty else {
            tracker.track(.share(.failed(origin: .history, count: 0, activity: nil, error: nil)))
            return
        }
        model.delegate?.aiuta(eventOccurred: .shareGeneratedImages(photosCount: imagesToShare.count))
        let result = await share(images: imagesToShare)
        if result.isSucceeded {
            isEditMode = false
        }
        switch result {
            case let .succeeded(activity):
                tracker.track(.share(.success(origin: .history, count: imagesToShare.count, activity: activity)))
            case let .canceled(activity):
                tracker.track(.share(.cancelled(origin: .history, count: imagesToShare.count, activity: activity)))
            case let .failed(activity, error):
                tracker.track(.share(.failed(origin: .history, count: imagesToShare.count, activity: activity, error: error)))
        }
    }

    func enterFullscreen(_ cell: AiutaGenerationsHistoryCell) {
        let gallery = AiutaGeneratedGalleryViewController(ui.history.data, start: cell.index.item)
        gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, gallery in
            Task {
                guard let image = try? await generatedImage.fetch() else { return }
                tracker.track(.share(.start(origin: .history, count: 1, hasText: false)))
                model.delegate?.aiuta(eventOccurred: .shareGeneratedImages(photosCount: 1))
                let result = await gallery.share(image: watermarker.watermark(image))
                switch result {
                    case let .succeeded(activity):
                        tracker.track(.share(.success(origin: .history, count: 1, activity: activity)))
                    case let .canceled(activity):
                        tracker.track(.share(.cancelled(origin: .history, count: 1, activity: activity)))
                    case let .failed(activity, error):
                        tracker.track(.share(.failed(origin: .history, count: 1, activity: activity, error: error)))
                }
            }
        }
        present(gallery)
    }
}
