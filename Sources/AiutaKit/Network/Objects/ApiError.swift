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

@available(iOS 13.0.0, *)
@_spi(Aiuta) public enum ApiError: Error, LocalizedError {
    case afError(AFError?)
    case statusCode(Int, String?)
    case failed(String?)

    public var errorDescription: String? {
        switch self {
            case let .afError(afError):
                if let afError { return afError.errorDescription }
                else { return "Unknown error" }
            case let .statusCode(code, rawResponse):
                if let rawResponse { return "\(code): \(rawResponse)" }
                else { return "Response code \(code)" }
            case let .failed(description):
                let reason: String
                if let description { reason = "\(description)\n" } else { reason = "" }
                return "\(reason)Please check your internet\nconnection or try again later."
        }
    }
}
