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
@_spi(Aiuta) public enum ApiError: Error {
    case notModified
    case retry

    case badRequest(String?)
    case unauthorized(String?)
    case paymentRequired(String?)
    case notFound(String?)
    case validationError(String?)
    case highLoad(String?)

    case failed(String?)
    case alamofireError(Error)
    case sessionError(String, Error?)
}

@available(iOS 13.0.0, *) extension ApiError {
    init(_ statusCode: Int, with info: String?) {
        switch statusCode {
            case 304: self = .notModified
            case 400: self = .badRequest(info)
            case 401: self = .unauthorized(info)
            case 402: self = .paymentRequired(info)
            case 404: self = .notFound(info)
            case 422: self = .validationError(info)
            case 429: self = .highLoad(info)
            default: self = .failed(info)
        }
    }

    init(_ afError: AFError?) {
        guard let afError else {
            self = .failed(nil)
            return
        }

        switch afError {
            case let .sessionTaskFailed(error):
                self = .sessionError(error.localizedDescription, error)
            default: self = .alamofireError(afError)
        }
    }
}

@available(iOS 13.0.0, *) extension ApiError {
    struct Info: Codable {
        private let detail: String?

        var error: String? { detail }
    }
}

@available(iOS 13.0.0, *) extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .notModified, .retry: return nil
            case let .badRequest(info): return info ?? "Bad request"
            case let .unauthorized(info): return info ?? "Please sign in"
            case let .paymentRequired(info): return info ?? "Please subscribe"
            case let .notFound(info): return info ?? "Not found"
            case let .validationError(info): return info ?? "Incorrect request"
            case let .highLoad(info): return info ?? "High load.\nPlease try again later."
            case let .failed(info): return info ?? "Unknown error"
            case let .alamofireError(afError): return afError.localizedDescription
            case let .sessionError(info, _):
                return "\(info)\nPlease check your internet\nconnection or try again later."
        }
    }
}
