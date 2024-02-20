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

import Alamofire
import Foundation

extension Aiuta {
    struct UploadedImage: Codable {
        let id: String
        let url: String
    }
}

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

extension Aiuta.UploadedImage: Equatable {
    static func == (lhs: Aiuta.UploadedImage, rhs: Aiuta.UploadedImage) -> Bool {
        lhs.id == rhs.id
    }
}
