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
    import AiutaConfig
    import AiutaCore
    @_spi(Aiuta) import AiutaKit
#endif
import Foundation

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class SessionImpl: Session {
        @injected var tracker: AnalyticTracker
        @injected var config: Aiuta.Configuration

        var products: Aiuta.Products = []
        private var pendingTryOnResult: Aiuta.TryOnResult = .exit
        private var pendingSizeFitResult: Aiuta.SizeFitResult = .exit

        func start() {
            products = []
            pendingTryOnResult = .exit
            pendingSizeFitResult = .exit
        }

        func start(with products: Aiuta.Products) {
            self.products = products
            pendingTryOnResult = .exit
            pendingSizeFitResult = .exit
        }

        func finish(addingToCart products: Aiuta.Products?) {
            guard let products, !products.isEmpty else { return }
            if products.count == 1 {
                pendingTryOnResult = .addProductToCart(productId: products[0].id)
            } else {
                pendingTryOnResult = .addOutfitToCart(productIds: products.map(\.id))
            }
        }

        func finish(recommendingSize recommendation: Aiuta.SizeRecommendation?) {
            guard let product = products.first,
                  let size = recommendation?.recommendedSizeName else { return }
            pendingSizeFitResult = .recommendSize(productId: product.id, size: size)
        }

        func flushTryOnResult() -> Aiuta.TryOnResult {
            defer { pendingTryOnResult = .exit }
            switch pendingTryOnResult {
                case .exit:
                    break
                case let .addProductToCart(productId):
                    if let cartHandler = config.features.tryOn.cart?.handler {
                        Task { await cartHandler.addToCart(productId: productId) }
                    }
                case let .addOutfitToCart(productIds):
                    if let outfitHandler = config.features.tryOn.cart?.outfit?.handler {
                        Task { await outfitHandler.addToCartOutfit(productIds: productIds) }
                    }
            }
            return pendingTryOnResult
        }

        func flushSizeFitResult() -> Aiuta.SizeFitResult {
            defer { pendingSizeFitResult = .exit }
            switch pendingSizeFitResult {
                case .exit:
                    break
                case let .recommendSize(productId, size):
                    if let sizeHandler = config.features.sizeFit?.handler {
                        Task { await sizeHandler.reccomendation(productId: productId, size: size) }
                    }
            }
            return pendingSizeFitResult
        }
    }
}
