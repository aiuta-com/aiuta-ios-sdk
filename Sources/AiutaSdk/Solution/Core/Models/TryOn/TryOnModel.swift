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

@available(iOS 13.0.0, *)
protocol TryOnModel {
    var sessionResults: DataProvider<TryOnResult> { get }

    func tryOn(_ source: ImageSource, with sku: Aiuta.Product?, status callback: @escaping (TryOnStatus) -> Void) async throws -> TryOnStats
}

enum TryOnStatus {
    case uploadingImage, scanningBody, generatingOutfit
}

enum TryOnError: Error {
    case noSku, prepareImageFailed, uploadImageFailed, tryOnFailed, tryOnTimeout, emptyResults, tryOnAborted
}

protocol TryOnStats {
    var uploadDuration: TimeInterval { get }
    var tryOnDuration: TimeInterval { get }
    var downloadDuration: TimeInterval { get }
}

extension TryOnStats {
    var totalDuration: TimeInterval { uploadDuration + tryOnDuration + downloadDuration }
}

extension TryOnError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .noSku: return "No SKU provided."
            case .prepareImageFailed: return "Failed to prepare image."
            case .uploadImageFailed: return "Failed to upload image."
            case .tryOnFailed: return "Opertaion status failed or cancelled."
            case .emptyResults: return "Completed with empty results."
            case .tryOnAborted: return "No people were found in the image."
            case .tryOnTimeout: return "Operation timed out."
        }
    }
}

struct TryOnResult {
    private let id: String
    let image: Aiuta.Image
    let sku: Aiuta.Product

    init(id: String, image: Aiuta.Image, sku: Aiuta.Product) {
        self.id = id
        self.image = image
        self.sku = sku
    }
}

extension TryOnResult: Equatable {
    static func == (lhs: TryOnResult, rhs: TryOnResult) -> Bool {
        lhs.id == rhs.id
    }
}
