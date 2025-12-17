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

@_spi(Aiuta) import AiutaCore
@_spi(Aiuta) import AiutaKit

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class HistoryImpl: History {
        @injected private var config: Sdk.Configuration

        var deletingUploaded = DataProvider<Aiuta.InputImage>()
        var deletingGenerated = DataProvider<Aiuta.GeneratedImage>()

        var uploaded = DataProvider<Aiuta.InputImage>()
        var generated = DataProvider<Aiuta.GeneratedImage>()
        var hasUploads: Bool { !uploaded.isEmpty }
        var hasGenerations: Bool { !generated.isEmpty }

        init() {
            Task { await subscribeForChanges() }
        }

        @MainActor func subscribeForChanges() async {
            if config.features.imagePicker.hasUploadsHistory {
                let uploads = await config.features.imagePicker.historyProvider.uploaded
                await uploads.addListener { [weak self] newValue in
                    self?.uploaded.items = newValue
                }
            }

            if config.features.tryOn.hasGenerationsHistory {
                let generations = await config.features.tryOn.historyProvider.generated
                await generations.addListener { [weak self] newValue in
                    self?.generated.items = newValue
                }
            }
        }

        @MainActor func addUploaded(_ image: Aiuta.UserImage) async throws {
            guard config.features.imagePicker.hasUploadsHistory else { return }
            try await config.features.imagePicker.historyProvider.add(uploaded: [image])
        }

        @MainActor func touchUploaded(with id: String) async throws -> Bool {
            guard config.features.imagePicker.hasUploadsHistory else { return true }
            guard let selectedImage = await config.features.imagePicker.historyProvider.uploaded.value.first(where: { $0.id == id }) else {
                return false
            }
            try await config.features.imagePicker.historyProvider.select(uploaded: selectedImage)
            return true
        }

        @MainActor func removeUploaded(_ image: Aiuta.UserImage) async throws {
            guard config.features.imagePicker.hasUploadsHistory else { return }
            deletingUploaded.items.append(image)
            defer { deletingUploaded.removeAll(where: { $0.id == image.id }) }
            try await config.features.imagePicker.historyProvider.delete(uploaded: [image])
        }

        @MainActor func addGenerated(_ images: [Aiuta.UserImage], for products: Aiuta.Products) async throws {
            guard config.features.tryOn.hasGenerationsHistory else { return }
            let generatedImages = images.map { Aiuta.GeneratedImage(image: $0, productIds: products.ids) }
            try await config.features.tryOn.historyProvider.add(generated: generatedImages)
        }

        @MainActor func removeGenerated(_ selection: [Aiuta.GeneratedImage]) async throws {
            guard config.features.tryOn.hasGenerationsHistory else { return }
            deletingGenerated.items.append(contentsOf: selection)
            defer { deletingGenerated.removeAll { selection.contains($0) } }
            try await config.features.tryOn.historyProvider.delete(generated: selection)
        }
    }
}

extension Sdk.Configuration.Features.ImagePicker {
    final class DefaultsDataProvider: Aiuta.Configuration.Features.ImagePicker.UploadsHistory.DataProvider {
        @MainActor
        @defaults(key: "uploadedHistory", defaultValue: .init([]))
        var uploaded: Aiuta.Observable<[Aiuta.InputImage]>

        @available(iOS 13.0.0, *)
        @MainActor
        func add(uploaded images: [Aiuta.InputImage]) async throws {
            uploaded.value.insert(contentsOf: images, at: 0)
        }

        @available(iOS 13.0.0, *)
        @MainActor
        func delete(uploaded images: [Aiuta.InputImage]) async throws {
            uploaded.value.removeAll { image in images.contains(image) }
        }

        @available(iOS 13.0.0, *)
        @MainActor
        func select(uploaded image: Aiuta.InputImage) async throws {
            guard let index = uploaded.value.firstIndex(where: { $0.id == image.id }) else { return }
            let selectedImage = uploaded.value.remove(at: index)
            uploaded.value.insert(selectedImage, at: 0)
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
        }
    }
}

extension Sdk.Configuration.Features.TryOn {
    final class DefaultsDataProvider: Aiuta.Configuration.Features.TryOn.GenerationsHistory.DataProvider {
        @MainActor
        @defaults(key: "generationHistory", defaultValue: .init([]))
        var generated: Aiuta.Observable<[Aiuta.GeneratedImage]>

        @available(iOS 13.0.0, *)
        @MainActor
        func add(generated images: [Aiuta.GeneratedImage]) async throws {
            generated.value.insert(contentsOf: images, at: 0)
        }

        @available(iOS 13.0.0, *)
        @MainActor
        func delete(generated images: [Aiuta.GeneratedImage]) async throws {
            generated.value.removeAll { image in images.contains(image) }
        }
    }
}
