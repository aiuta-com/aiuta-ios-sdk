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

#if SWIFT_PACKAGE
    import AiutaCore
#endif

extension Aiuta {
    /// The outcome of a size fitting session, returned when the SDK is dismissed.
    ///
    /// This value indicates why the size fit flow ended — whether the user simply
    /// closed the SDK, or got a size recommendation.
    public enum SizeFitResult {
        /// The user dismissed the SDK without accepting a size recommendation.
        case exit

        /// The user got the recommended size for a product.
        ///
        /// - Parameters:
        ///   - productId: The identifier of the product.
        ///   - size: The recommended size name.
        case recommendSize(productId: String, size: String)
    }
}
