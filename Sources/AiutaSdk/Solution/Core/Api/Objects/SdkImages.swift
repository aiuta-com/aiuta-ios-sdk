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
import Alamofire
import Foundation

extension Aiuta.UploadedImage {
    struct Post: Encodable, ApiRequest {
        var urlPath: String { "uploaded_images" }
        var type: ApiRequestType { .upload }
        var method: HTTPMethod { .post }

        let imageData: Data

        func multipartFormData(_ data: MultipartFormData) {
            data.append(imageData, withName: "image_data", fileName: "image.jpg", mimeType: "image/jpeg")
        }
    }
}

extension Aiuta.UploadedImage: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, url
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
    }
}

extension Aiuta.GeneratedImage: Codable {
    private enum CodingKeys: String, CodingKey {
        case url = "imageUrl"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
    }
}

extension Aiuta.UploadedImage: Equatable {
    public static func == (lhs: Aiuta.UploadedImage, rhs: Aiuta.UploadedImage) -> Bool {
        lhs.id == rhs.id
    }
}

extension Aiuta.GeneratedImage: Equatable {
    public static func == (lhs: Aiuta.GeneratedImage, rhs: Aiuta.GeneratedImage) -> Bool {
        lhs.url == rhs.url
    }
}

@_spi(Aiuta) extension Aiuta.GeneratedImage: TransitionRef {
    public var transitionId: String { url }
}

@_spi(Aiuta) extension Aiuta.UploadedImage: ImageSource {
    public var knownRemoteId: String? { id }

    public func fetcher(for quality: ImageQuality, breadcrumbs: Breadcrumbs) -> ImageFetcher {
        UrlFetcher(url, quality: quality, breadcrumbs: breadcrumbs)
    }
}

@_spi(Aiuta) extension Aiuta.UploadedImage: TransitionRef {
    public var transitionId: String { url }
}

@_spi(Aiuta) extension Aiuta.GeneratedImage: ImageSource {
    public var knownRemoteId: String? { nil }

    public func fetcher(for quality: ImageQuality, breadcrumbs: Breadcrumbs) -> ImageFetcher {
        UrlFetcher(url, quality: quality, breadcrumbs: breadcrumbs)
    }
}
