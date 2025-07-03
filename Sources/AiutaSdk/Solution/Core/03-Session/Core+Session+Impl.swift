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
extension Sdk.Core {
    final class SessionImpl: Session {
        @injected var tracker: AnalyticTracker
        @injected var config: Sdk.Configuration

        var products: Aiuta.Products = []

        func start() {
            products = []
        }

        func start(with product: Aiuta.Product) {
            products = [product]
        }

        func finish(addingToCart product: Aiuta.Product?) {
            guard let product else { return }
            Task { await config.features.tryOn.cartHandler?.addToCart(productId: product.id) }
        }
    }
}
