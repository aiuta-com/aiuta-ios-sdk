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
    @injected private var history: Sdk.Core.History
    @injected private var session: Sdk.Core.Session
    @injected private var tracker: AnalyticTracker
    @injected private var watermarker: Watermarker
    @injected private var config: Sdk.Configuration

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
            if !isEditMode { ui.errorSnackbar.hide() }
        }

        ui.selectionSnackbar.bar.cancelButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            isEditMode = false
        }

        ui.selectionSnackbar.bar.gestures.onSwipe(.down, with: self) { [unowned self] _ in
            isEditMode = false
        }

        ui.selectionSnackbar.bar.toggleSeletionButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if isSelectedAll { selection.removeAll() }
            else { selection = Set(history.generated.items) }
            updateSelection()
        }

        ui.selectionSnackbar.bar.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard !selection.isEmpty else { return }
            Task { await shareSelection() }
        }

        ui.selectionSnackbar.bar.deleteButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            Task { await deleteSelection() }
        }

        ui.history.onUpdateItem.subscribe(with: self) { [unowned self] cell in
            guard let image = cell.data else {
                cell.isSelectable = false
                return
            }
            cell.isDeleting = history.deletingGenerated.items.contains(image)
            cell.isSelectable = isEditMode && !cell.isDeleting
            cell.isSelected = isEditMode && !cell.isDeleting && selection.contains(image)
        }

        ui.history.onTapItem.subscribe(with: self) { [unowned self] cell in
            if isEditMode { toggleSelection(cell) }
            else { enterFullscreen(cell) }
        }

        history.deletingGenerated.onUpdate.subscribe(with: self) { [unowned self] in
            ui.history.updateItems()
        }

        ui.errorSnackbar.bar.tryAgain.onTouchUpInside.subscribe(with: self) { [unowned self] in
            Task { await deleteSelection() }
        }

        ui.errorSnackbar.onTouchDown.subscribe(with: self) { [unowned self] in
            if !isEditMode { selection.removeAll() }
            ui.errorSnackbar.isVisible = false
        }

        ui.history.data = history.generated
        ui.navBar.isActionAvailable = true

        tracker.track(.page(pageId: page, productIds: session.products.ids))
    }

    private var isEditMode = false {
        didSet {
            guard oldValue != isEditMode else { return }
            ui.selectionSnackbar.isVisible = isEditMode
            ui.navBar.actionStyle = .label(isEditMode ? ds.strings.cancel : ds.strings.select)
            ui.history.updateItems()
            if !isEditMode { selection.removeAll() }
            updateSelection()
        }
    }

    private var selection = Set<Aiuta.Image.Generated>() {
        didSet {
            guard oldValue != selection else { return }
            ui.history.updateItems()
        }
    }

    var isSelectedAll: Bool {
        !selection.isEmpty && (selection.count == history.generated.items.count)
    }

    func toggleSelection(_ cell: HistoryView.HistoryCell) {
        guard let image = cell.data else { return }
        if selection.contains(image) {
            selection.remove(image)
        } else {
            selection.insert(image)
        }
        updateSelection()
    }

    func updateSelection() {
        ui.selectionSnackbar.bar.deleteButton.isEnabled = !selection.isEmpty
        ui.selectionSnackbar.bar.shareButton.isEnabled = !selection.isEmpty

        ui.selectionSnackbar.bar.toggleSeletionButton.text = isSelectedAll ? ds.strings.unselectAll : ds.strings.selectAll
        ui.selectionSnackbar.bar.view.layoutSubviews()
    }

    func deleteSelection() async {
        ui.errorSnackbar.hide()
        let candidates = selection
        isEditMode = false
        guard !candidates.isEmpty else { return }
        do {
            try await history.removeGenerated(Array(candidates))
            tracker.track(.history(event: .generatedImageDeleted, pageId: page, productIds: session.products.ids))

            if !history.hasGenerations {
                dispatch(.mainAsync) { [self] in
                    dismiss()
                }
            }
        } catch {
            ui.errorSnackbar.show()
            selection.formUnion(candidates)
        }
    }

    func shareSelection() async {
        ui.selectionSnackbar.bar.shareButton.activity.start()
        let imagesToShare: [UIImage] = await selection.concurrentCompactMap { [watermarker, breadcrumbs] in
            guard let image = try? await $0.fetch(breadcrumbs: breadcrumbs.fork()) else { return nil }
            return watermarker.watermark(image)
        }
        guard !imagesToShare.isEmpty else {
            ui.selectionSnackbar.bar.shareButton.activity.stop()
            return
        }
        let productIds = selection.compactMap { $0.productIds }.flatMap { $0 }.uniqued()
        tracker.track(.share(event: .initiated, pageId: page, productIds: productIds))
        let attachment = try? await config.features.share.additionalTextProvider?.getShareText(productIds: productIds)
        ui.selectionSnackbar.bar.shareButton.activity.stop()

        let result = await share(images: imagesToShare.map { watermarker.watermark($0) },
                                 additions: [attachment].compactMap { $0 })
        if result.isSucceeded {
            isEditMode = false
        }
        switch result {
            case let .succeeded(activity):
                tracker.track(.share(event: .succeeded(targetId: activity), pageId: page, productIds: productIds))
            case let .canceled(activity):
                tracker.track(.share(event: .canceled(targetId: activity), pageId: page, productIds: productIds))
            case let .failed(activity, _):
                tracker.track(.share(event: .failed(targetId: activity), pageId: page, productIds: productIds))
        }
    }

    func enterFullscreen(_ cell: HistoryView.HistoryCell) {
        let gallery = GalleryViewController(TransformDataProvider(input: ui.history.data, transform: { $0 }), start: cell.index.item, crossfade: true)
        gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, _, gallery in
            Task {
                gallery.ui.activity.start()
                guard let image = try? await generatedImage.fetch(breadcrumbs: breadcrumbs.fork()) else {
                    gallery.ui.activity.stop()
                    return
                }

                let productIds = (generatedImage as? Aiuta.Image.Generated)?.productIds ?? []
                tracker.track(.share(event: .initiated, pageId: page, productIds: productIds))
                let attachment = try? await config.features.share.additionalTextProvider?.getShareText(productIds: productIds)
                gallery.ui.activity.stop()

                let result = await gallery.share(image: watermarker.watermark(image),
                                                 additions: [attachment].compactMap { $0 })
                switch result {
                    case let .succeeded(activity):
                        tracker.track(.share(event: .succeeded(targetId: activity), pageId: page, productIds: productIds))
                    case let .canceled(activity):
                        tracker.track(.share(event: .canceled(targetId: activity), pageId: page, productIds: productIds))
                    case let .failed(activity, _):
                        tracker.track(.share(event: .failed(targetId: activity), pageId: page, productIds: productIds))
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
