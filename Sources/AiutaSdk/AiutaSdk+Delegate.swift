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

import Foundation

/// This protocol defines the delegate methods for receiving callbacks from the Aiuta SDK.
public protocol AiutaSdkDelegate: AnyObject {
    /// Called when a user selects to add an SKU to their wishlist.
    func aiuta(addToWishlist skuId: String)

    /// Called when a user selects to add an SKU to their cart.
    func aiuta(addToCart skuId: String)

    /// Called when a user selects to view more details about an SKU.
    func aiuta(showSku skuId: String)

    /// Called when significant event occurred in SDK.
    /// See `Aiuta.SdkEvent` for details.
    func aiuta(eventOccurred event: Aiuta.Event)
}

public extension AiutaSdkDelegate {
    /// Making this delegate method optional with warning.
    func aiuta(eventOccurred event: Aiuta.Event) {
        print("(i) AiutaSDK: Implement aiuta(eventOccurred:) in your AiutaSdkDelegate to remove this warning and track `\(event)` event.")
    }
}
