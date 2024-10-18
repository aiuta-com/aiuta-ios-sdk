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

import Foundation

public protocol AiutaDataController: AnyObject {
    func setData(provider: AiutaDataProvider)
    func obtainUserConsent()
    func addUploaded(images: [Aiuta.UploadedImage])
    func selectUploaded(image: Aiuta.UploadedImage)
    func deleteUploaded(images: [Aiuta.UploadedImage])
    func addGenerated(images: [Aiuta.GeneratedImage])
    func deleteGenerated(images: [Aiuta.GeneratedImage])
}

// MARK: - Data provider

public protocol AiutaDataProvider: AnyObject {
    var isUserConsentObtained: Bool { get set }
    var uploadedImages: [Aiuta.UploadedImage] { get set }
    var generatedImages: [Aiuta.GeneratedImage] { get set }
}

// MARK: - Data structs

extension Aiuta {
    public struct UploadedImage {
        public let id: String
        public let url: String

        public init(id: String, url: String) {
            self.id = id
            self.url = url
        }
    }

    public struct GeneratedImage {
        public let url: String

        public init(url: String) {
            self.url = url
        }
    }
}
