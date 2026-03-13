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
    /// The outcome of a virtual try-on session, returned when the SDK is dismissed.
    ///
    /// This value indicates why the try-on flow ended — whether the user simply
    /// closed the SDK, or took a specific action such as adding items to the cart.
    public enum TryOnResult {
        /// The user dismissed the SDK without performing any cart action.
        case exit

        /// The user added a single product to the cart.
        ///
        /// - Parameter productId: The identifier of the product the user chose to add.
        case addProductToCart(productId: String)

        /// The user added an entire outfit (multiple products) to the cart.
        ///
        /// - Parameter productIds: The identifiers of all products in the outfit.
        case addOutfitToCart(productIds: [String])
    }
}
