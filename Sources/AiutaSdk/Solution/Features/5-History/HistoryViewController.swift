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
final class HistoryViewController: ViewController<HistoryView> {
    @injected private var history: HistoryModel
    @injected private var session: SessionModel
    @injected private var tracker: AnalyticTracker
    @injected private var watermarker: Watermarker
    private let breadcrumbs = Breadcrumbs()

    override func setup() {
        ui.navBar.onBack.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onAction.subscribe(with: self) { [unowned self] in
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
            else { selection = history.generated.items }
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

        ui.history.data = history.generated
        ui.navBar.isActionAvailable = true

        session.delegate?.aiuta(eventOccurred: .page(pageId: page))
    }

    private var isEditMode = false {
        didSet {
            guard oldValue != isEditMode else { return }
            ui.selectionSnackbar.isVisible = isEditMode
            ui.navBar.actionStyle = .label(isEditMode ? L.cancel : L.appBarSelect)
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
        !selection.isEmpty && (selection.count == history.generated.items.count)
    }

    func toggleSelection(_ cell: HistoryView.HistoryCell) {
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

        ui.selectionSnackbar.bar.toggleSeletionButton.text = isSelectedAll ? L.historySelectorEnableButtonUnselectAll : L.historySelectorEnableButtonSelectAll
        ui.selectionSnackbar.bar.view.layoutSubviews()
    }

    func deleteSelection() {
        history.removeGenerated(selection)
        if !selection.isEmpty {
            session.delegate?.aiuta(eventOccurred: .history(event: .generatedImageDeleted))
        }
        isEditMode = false
        if !history.hasGenerations {
            dismiss()
        }
    }

    func shareSelection() async {
        tracker.track(.share(.start(origin: .history, count: selection.count, text: nil)))
        let imagesToShare: [UIImage] = await selection.concurrentCompactMap { [watermarker, breadcrumbs] in
            guard let image = try? await $0.fetch(breadcrumbs: breadcrumbs.fork()) else { return nil }
            return watermarker.watermark(image)
        }
        guard !imagesToShare.isEmpty else {
            tracker.track(.share(.failed(origin: .history, count: 0, activity: nil, error: nil)))
            return
        }
        session.delegate?.aiuta(eventOccurred: .history(event: .generatedImageShared))
        let result = await share(images: imagesToShare)
        if result.isSucceeded {
            isEditMode = false
        }
        switch result {
            case let .succeeded(activity):
                tracker.track(.share(.success(origin: .history, count: imagesToShare.count, activity: activity, text: nil)))
            case let .canceled(activity):
                tracker.track(.share(.cancelled(origin: .history, count: imagesToShare.count, activity: activity)))
            case let .failed(activity, error):
                tracker.track(.share(.failed(origin: .history, count: imagesToShare.count, activity: activity, error: error)))
        }
    }

    func enterFullscreen(_ cell: HistoryView.HistoryCell) {
        let gallery = GalleryViewController(TransformDataProvider(input: ui.history.data, transform: { $0 }), start: cell.index.item)
        gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, _, gallery in
            Task {
                guard let image = try? await generatedImage.fetch(breadcrumbs: breadcrumbs.fork()) else { return }
                tracker.track(.share(.start(origin: .history, count: 1, text: nil)))
                let result = await gallery.share(image: watermarker.watermark(image))
                switch result {
                    case let .succeeded(activity):
                        tracker.track(.share(.success(origin: .history, count: 1, activity: activity, text: nil)))
                        session.delegate?.aiuta(eventOccurred: .history(event: .generatedImageShared))
                    case let .canceled(activity):
                        tracker.track(.share(.cancelled(origin: .history, count: 1, activity: activity)))
                    case let .failed(activity, error):
                        tracker.track(.share(.failed(origin: .history, count: 1, activity: activity, error: error)))
                }
            }
        }
        cover(gallery)
    }
}

@available(iOS 13.0.0, *)
extension HistoryViewController: PageRepresentable {
    var page: Aiuta.Event.Page { .history }
    var isSafeToDismiss: Bool { true }
}
