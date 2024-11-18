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

import UIKit

@_spi(Aiuta) public protocol ImageFetcher: AnyObject {
    var onImage: Signal<UIImage?> { get }
    var onError: Signal<Void> { get }
}

@available(iOS 13.0.0, *)
@_spi(Aiuta) public extension ImageFetcher {
    @MainActor func fetch() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            onImage.subscribePastOnce(with: self) { image in
                if let image { continuation.resume(returning: image) }
                else { continuation.resume(throwing: ImageFetchError(message: "Can't load image")) }
            }
        }
    }
}

@_spi(Aiuta) public struct ImageFetchError: Error, LocalizedError {
    let message: String

    public var errorDescription: String? {
        return message
    }
}
