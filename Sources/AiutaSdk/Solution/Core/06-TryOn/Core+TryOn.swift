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
import Foundation

extension Sdk.Core {
    protocol TryOn {
        var sessionResults: DataProvider<TryOnResult> { get }

        @available(iOS 13.0.0, *)
        func tryOn(_ source: ImageSource, with products: Aiuta.Products?, status callback: @escaping (TryOnStatus) -> Void) async throws -> TryOnStats

        func abortAll()
    }
}

extension Sdk.Core {
    enum TryOnStatus {
        case uploadingImage, imageUploaded, scanningBody, generatingOutfit
    }

    enum TryOnError: Error {
        case error(Aiuta.Event.TryOn.ErrorType, underlying: Error? = nil)
        case abort
        case terminate
        case unknown(Error)
    }

    protocol TryOnStats {
        var uploadDuration: TimeInterval { get }
        var tryOnDuration: TimeInterval { get }
        var downloadDuration: TimeInterval { get }
    }
}

extension Sdk.Core.TryOnStats {
    var totalDuration: TimeInterval { uploadDuration + tryOnDuration + downloadDuration }
}

extension Sdk.Core.TryOnError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case let .error(t, u):
                if let u {
                    return u.localizedDescription
                }
                switch t {
                    case .preparePhotoFailed: return "Failed to prepare image."
                    case .uploadPhotoFailed: return "Failed to upload image."
                    case .authorizationFailed: return "Failed to authorize the request."
                    case .requestOperationFailed: return "Failed to start the operation."
                    case .startOperationFailed: return "Failed to start the operation."
                    case .operationFailed: return "Operation status failed or cancelled."
                    case .operationTimeout: return "Operation timed out."
                    case .operationEmptyResults: return "Completed with empty results."
                    case .downloadResultFailed: return "Failed to download results."
                    case .internalSdkError: return "An internal SDK error occurred."
                }
            case .abort: return "No people were found in the image."
            case .terminate: return "Operation terminated."
            case let .unknown(e): return e.localizedDescription
        }
    }
}

extension Sdk.Core {
    struct TryOnResult {
        private let id: String
        let image: Aiuta.Image
        let products: Aiuta.Products

        init(id: String, image: Aiuta.Image, products: Aiuta.Products) {
            self.id = id
            self.image = image
            self.products = products
        }
    }
}

extension Sdk.Core.TryOnResult: Equatable {
    static func == (lhs: Sdk.Core.TryOnResult, rhs: Sdk.Core.TryOnResult) -> Bool {
        lhs.id == rhs.id
    }
}
