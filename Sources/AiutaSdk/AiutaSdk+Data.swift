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

@available(iOS 13.0.0, *)
public protocol AiutaDataController: AnyObject {
    func setData(provider: AiutaDataProvider)

    func obtainUserConsent() async throws

    func addUploaded(images: [Aiuta.Image]) async throws
    func selectUploaded(image: Aiuta.Image) async throws
    func deleteUploaded(images: [Aiuta.Image]) async throws

    func addGenerated(images: [Aiuta.Image]) async throws
    func deleteGenerated(images: [Aiuta.Image]) async throws
}

// MARK: - Data provider

public protocol AiutaDataProvider: AnyObject {
    var isUserConsentObtained: Bool { get set }
    var uploadedImages: [Aiuta.Image] { get set }
    var generatedImages: [Aiuta.Image] { get set }
    func setProduct(_ product: Aiuta.Product, isInWishlist: Bool)
}

// MARK: - Data structs

extension Aiuta {
    public struct Image: Codable {
        public let id: String
        public let url: String

        public init(id: String, url: String) {
            self.id = id
            self.url = url
        }
    }
}

extension Aiuta.Image: Equatable {
    public static func == (lhs: Aiuta.Image, rhs: Aiuta.Image) -> Bool {
        lhs.id == rhs.id
    }
}

extension Aiuta.Image: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
