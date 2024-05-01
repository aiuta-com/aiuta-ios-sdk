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

@_spi(Aiuta) public extension HTTPHeader {
    static func ifNoneMatch(_ value: String) -> HTTPHeader {
        HTTPHeader(name: "if-none-match", value: value)
    }

    static func authorization(xApiKey value: String) -> HTTPHeader {
        HTTPHeader(name: "x-api-key", value: value)
    }
}

@_spi(Aiuta) public extension HTTPHeaders {
    var etag: String? { value(for: "Etag") }
}
