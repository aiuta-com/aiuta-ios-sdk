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

@available(iOS 13.0.0, *)
final class HistoryModelImpl: HistoryModel {
    @injected private var sessionModel: SessionModel
    @injected private var config: Aiuta.Configuration

    var deletingUploaded = DataProvider<Aiuta.Image>()
    var deletingGenerated = DataProvider<Aiuta.Image>()

    private let defaults = UserDefaultsHistoryController()
    var uploaded: DataProvider<Aiuta.Image> { defaults.uploaded }
    var generated: DataProvider<Aiuta.Image> { defaults.generated }
    var hasUploads: Bool { !defaults.uploadedHistory.isEmpty }
    var hasGenerations: Bool { !defaults.generatedHistory.isEmpty }
    var controller: AiutaDataController { sessionModel.controller ?? defaults }

    @MainActor func addUploaded(_ image: Aiuta.Image) async throws {
        guard config.behavior.isUploadsHistoryAvailable else { return }
        try await controller.addUploaded(images: [image])
    }

    @MainActor func touchUploaded(with id: String) async throws {
        guard let selectedImage = defaults.uploadedHistory.first(where: { $0.id == id }) else { return }
        try await controller.selectUploaded(image: selectedImage)
    }

    @MainActor func removeUploaded(_ image: Aiuta.Image) async throws {
        deletingUploaded.items.append(image)
        defer { deletingUploaded.removeAll(where: { $0.id == image.id }) }
        try await controller.deleteUploaded(images: [image])
    }

    func setUploaded(_ history: [Aiuta.Image]) {
        guard config.behavior.isUploadsHistoryAvailable else { return }
        defaults.uploadedHistory = history
        deletingUploaded.removeAll(where: { !history.contains($0) })
    }

    @MainActor func addGenerated(_ images: [Aiuta.Image], for product: Aiuta.Product) async throws {
        guard config.behavior.isTryonHistoryAvailable else { return }
        try await controller.addGenerated(images: images, for: product.skuId)
    }

    @MainActor func removeGenerated(_ selection: [Aiuta.Image]) async throws {
        guard !selection.isEmpty else { return }
        deletingGenerated.items.append(contentsOf: selection)
        defer { deletingGenerated.removeAll { selection.contains($0) } }
        try await controller.deleteGenerated(images: selection)
    }

    func setGenerated(_ history: [Aiuta.Image]) {
        guard config.behavior.isTryonHistoryAvailable else { return }
        defaults.generatedHistory = history
        deletingGenerated.removeAll(where: { !history.contains($0) })
    }
}

// MARK: - UserDefaults History Storage

@available(iOS 13.0.0, *)
private final class UserDefaultsHistoryController: AiutaDataController {
    @injected private var config: Aiuta.Configuration

    var uploaded = DataProvider<Aiuta.Image>()
    var generated = DataProvider<Aiuta.Image>()

    @defaults(key: "generationHistory", defaultValue: [])
    var generatedHistory: [Aiuta.Image]

    @defaults(key: "uploadedHistory", defaultValue: [])
    var uploadedHistory: [Aiuta.Image]

    @defaults(key: "uploadsHistory", defaultValue: nil)
    var oldUploadsHistory: [[Aiuta.Image]]?

    init() {
        if let oldUploadsHistory {
            uploadedHistory = Array(oldUploadsHistory.joined())
            _oldUploadsHistory.erase()
        }

        if !config.behavior.isTryonHistoryAvailable {
            _generatedHistory.erase()
        }

        if !config.behavior.isUploadsHistoryAvailable {
            _uploadedHistory.erase()
        }

        _uploadedHistory.onValueChanged.subscribe(with: self) { [unowned self] _ in
            uploaded.items = uploadedHistory
        }

        _generatedHistory.onValueChanged.subscribe(with: self) { [unowned self] _ in
            generated.items = generatedHistory
        }

        uploaded.items = uploadedHistory
        generated.items = generatedHistory
    }

    @MainActor func addUploaded(images: [Aiuta.Image]) async throws {
        uploadedHistory.insert(contentsOf: images, at: 0)
    }

    @MainActor func selectUploaded(image: Aiuta.Image) async throws {
        guard let index = uploadedHistory.firstIndex(where: { $0.id == image.id }) else { return }
        let selectedImage = uploadedHistory.remove(at: index)
        uploadedHistory.insert(selectedImage, at: 0)
    }

    @MainActor func deleteUploaded(images: [Aiuta.Image]) async throws {
        uploadedHistory.removeAll { image in images.contains(image) }
    }

    @MainActor func addGenerated(images: [Aiuta.Image], for _: String) async throws {
        generatedHistory.insert(contentsOf: images, at: 0)
    }

    @MainActor func deleteGenerated(images: [Aiuta.Image]) async throws {
        generatedHistory.removeAll { image in images.contains(image) }
    }

    func setData(provider: any AiutaDataProvider) { }
    func obtainUserConsent(supplementary: [Aiuta.Consent]) async throws { }
}
