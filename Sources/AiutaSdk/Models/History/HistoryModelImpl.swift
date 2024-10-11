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

final class HistoryModelImpl: HistoryModel {
    var uploaded = DataProvider<Aiuta.UploadedImage>()

    var generated = DataProvider<Aiuta.GeneratedImage>()

    @defaults(key: "generationHistory", defaultValue: [])
    var generatedHistory: [Aiuta.GeneratedImage]

    @defaults(key: "uploadedHistory", defaultValue: [])
    var uploadedHistory: [Aiuta.UploadedImage]

    @defaults(key: "uploadsHistory", defaultValue: nil)
    var oldUploadsHistory: [[Aiuta.UploadedImage]]?

    var hasUploads: Bool {
        !uploadedHistory.isEmpty
    }

    var hasGenerations: Bool {
        !generatedHistory.isEmpty
    }

    init() {
        if let oldUploadsHistory {
            uploadedHistory = Array(oldUploadsHistory.joined())
            _oldUploadsHistory.erase()
        }

        uploaded.items = uploadedHistory
        generated.items = generatedHistory

        _uploadedHistory.onValueChanged.subscribe(with: self) { [unowned self] _ in
            uploaded.items = uploadedHistory
        }

        _generatedHistory.onValueChanged.subscribe(with: self) { [unowned self] _ in
            generated.items = generatedHistory
        }
    }

    func addUploaded(_ image: Aiuta.UploadedImage) {
        uploadedHistory.insert(image, at: 0)
        if #available(iOS 13.0.0, *) {
            image.prefetch(.hiResImage, breadcrumbs: Breadcrumbs())
        }
    }

    func touchUploaded(with id: String) {
        guard let index = uploadedHistory.firstIndex(where: { $0.id == id }) else { return }
        uploadedHistory.insert(uploadedHistory.remove(at: index), at: 0)
    }
    
    func removeUploaded(_ image: Aiuta.UploadedImage) {
        uploadedHistory.removeAll { existing in
            existing.id == image.id
        }
    }

    func addGenerated(_ images: [Aiuta.GeneratedImage]) {
        generatedHistory.insert(contentsOf: images, at: 0)
    }

    func removeGenerated(_ selection: [Aiuta.GeneratedImage]) {
        generatedHistory.removeAll { image in
            selection.contains(image)
        }
    }
}
