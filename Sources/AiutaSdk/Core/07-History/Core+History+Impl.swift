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

#if SWIFT_PACKAGE
@_spi(Aiuta) import AiutaConfig
@_spi(Aiuta) import AiutaCore
@_spi(Aiuta) import AiutaKit
#endif

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class HistoryImpl: History {
        @injected private var config: Aiuta.Configuration

        var deletingUploaded = DataProvider<Aiuta.InputImage>()
        var deletingGenerated = DataProvider<Aiuta.GeneratedImage>()

        var uploaded = DataProvider<Aiuta.InputImage>()
        var generated = DataProvider<Aiuta.GeneratedImage>()
        var hasUploads: Bool { !uploaded.isEmpty }
        var hasGenerations: Bool { !generated.isEmpty }

        private var uploadsProvider: Aiuta.Configuration.Features.ImagePicker.UploadsHistory.DataProvider?
        private var generationsProvider: Aiuta.Configuration.Features.TryOn.GenerationsHistory.DataProvider?

        init() {
            Task { await subscribeForChanges() }
        }

        @MainActor func subscribeForChanges() async {
            if let uploadsHistory = config.features.imagePicker.uploadsHistory {
                let provider = uploadsHistory.resolveDataProvider()
                uploadsProvider = provider
                let uploads = await provider.uploaded
                uploads.didChange.subscribePast(with: self) { [weak self] newValue in
                    self?.uploaded.items = newValue
                }
            }

            if let generationsHistory = config.features.tryOn.generationsHistory {
                let provider = generationsHistory.resolveDataProvider()
                generationsProvider = provider
                let generations = await provider.generated
                generations.didChange.subscribePast(with: self) { [weak self] newValue in
                    self?.generated.items = newValue
                }
            }
        }

        @MainActor func addUploaded(_ image: Aiuta.UserImage) async throws {
            guard let uploadsProvider else { return }
            try await uploadsProvider.add(uploaded: [image])
        }

        @MainActor func touchUploaded(with id: String) async throws -> Bool {
            guard let uploadsProvider else { return true }
            guard let selectedImage = await uploadsProvider.uploaded.value.first(where: { $0.id == id }) else {
                return false
            }
            try await uploadsProvider.select(uploaded: selectedImage)
            return true
        }

        @MainActor func removeUploaded(_ image: Aiuta.UserImage) async throws {
            guard let uploadsProvider else { return }
            deletingUploaded.items.append(image)
            defer { deletingUploaded.removeAll(where: { $0.id == image.id }) }
            try await uploadsProvider.delete(uploaded: [image])
        }

        @MainActor func addGenerated(_ images: [Aiuta.UserImage], for products: Aiuta.Products) async throws {
            guard let generationsProvider else { return }
            let generatedImages = images.map { Aiuta.GeneratedImage(image: $0, productIds: products.ids) }
            try await generationsProvider.add(generated: generatedImages)
        }

        @MainActor func removeGenerated(_ selection: [Aiuta.GeneratedImage]) async throws {
            guard let generationsProvider else { return }
            deletingGenerated.items.append(contentsOf: selection)
            defer { deletingGenerated.removeAll { selection.contains($0) } }
            try await generationsProvider.delete(generated: selection)
        }
    }
}

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    func resolveDataProvider() -> DataProvider {
        switch history {
            case .userDefaults:
                return UploadsDefaultsDataProvider()
            case let .dataProvider(provider):
                return provider
        }
    }
}

extension Aiuta.Configuration.Features.TryOn.GenerationsHistory {
    func resolveDataProvider() -> DataProvider {
        switch history {
            case .userDefaults:
                return GenerationsDefaultsDataProvider()
            case let .dataProvider(provider):
                return provider
        }
    }
}

fileprivate final class UploadsDefaultsDataProvider: Aiuta.Configuration.Features.ImagePicker.UploadsHistory.DataProvider {
    @MainActor
    @defaults(key: "uploadedHistory", defaultValue: .init([]))
    var uploaded: Aiuta.Observable<[Aiuta.InputImage]>

    @available(iOS 13.0.0, *)
    @MainActor
    func add(uploaded images: [Aiuta.InputImage]) async throws {
        uploaded.value = images + uploaded.value
        _uploaded.write()
    }

    @available(iOS 13.0.0, *)
    @MainActor
    func delete(uploaded images: [Aiuta.InputImage]) async throws {
        uploaded.value = uploaded.value.filter { image in !images.contains(image) }
        _uploaded.write()
    }

    @available(iOS 13.0.0, *)
    @MainActor
    func select(uploaded image: Aiuta.InputImage) async throws {
        var items = uploaded.value
        guard let index = items.firstIndex(where: { $0.id == image.id }) else { return }
        let selectedImage = items.remove(at: index)
        items.insert(selectedImage, at: 0)
        uploaded.value = items
        _uploaded.write()
    }

    @defaults(key: "uploadsHistory", defaultValue: nil)
    var oldUploadsHistory: [[Aiuta.UserImage]]?

    init() {
        if let oldUploadsHistory {
            let uploadsHistory = Array(oldUploadsHistory.joined())
            _oldUploadsHistory.erase()
            if #available(iOS 13.0, *) {
                Task { await migrate(oldUploadsHistory: uploadsHistory) }
            }
        }
    }

    @available(iOS 13.0.0, *)
    @MainActor
    private func migrate(oldUploadsHistory: [Aiuta.InputImage]) async {
        guard uploaded.value.isEmpty else { return }
        uploaded.value = oldUploadsHistory
        _uploaded.write()
    }
}

fileprivate final class GenerationsDefaultsDataProvider: Aiuta.Configuration.Features.TryOn.GenerationsHistory.DataProvider {
    @MainActor
    @defaults(key: "generationHistory", defaultValue: .init([]))
    var generated: Aiuta.Observable<[Aiuta.GeneratedImage]>

    @available(iOS 13.0.0, *)
    @MainActor
    func add(generated images: [Aiuta.GeneratedImage]) async throws {
        generated.value = images + generated.value
        _generated.write()
    }

    @available(iOS 13.0.0, *)
    @MainActor
    func delete(generated images: [Aiuta.GeneratedImage]) async throws {
        generated.value = generated.value.filter { image in !images.contains(image) }
        _generated.write()
    }
}
