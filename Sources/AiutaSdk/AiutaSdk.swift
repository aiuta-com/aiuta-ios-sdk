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

import Hero
import Resolver
import UIKit

public enum Aiuta {
    /// Aiuta SDK Configuration.
    /// All parameters are optional, you can only change the parts you are interested in.
    public struct Configuration {
        public static let `default` = Configuration()

        public struct Appearance {
            /// Your brand's primary color.
            /// This color will be used for all significant interface elements,
            /// such as the main action button on the screen, progress bars, etc.
            public var brandColor: UIColor?

            /// Extra special attention color. The discounted price labels
            /// and the discount percentage background will be colored in it.
            public var accentColor: UIColor?

            /// The background tint color of all screens.
            /// This color will be diluted by the extraLight UIBlurEffect.
            public var backgroundTint: UIColor?

            public struct NavigationBar {
                /// A small image of your logo to embed in the navigation bar.
                public var logoImage: UIImage?

                /// The color of navigation bar elements, such as the back button,
                /// action button, or screen header, for places where the logo is not displayed.
                public var foregroundColor: UIColor?
            }

            /// Configuration for the navigation bar inside the SDK UI.
            public var navigationBar = NavigationBar()
        }

        public struct Behavior {
            /// The maximum number of photos that a user can select
            /// in the system piket for virtuall try on.
            public var photoSelectionLimit: Int = 10

            /// Controls the output of SDK debug logs
            public var isDebugLogsEnabled: Bool = false
        }

        /// UI configuration.
        public var appearance = Appearance()

        /// Behavior configuration.
        public var behavior = Behavior()

        public init() {}
    }

    public struct SkuInfo {
        public let skuId: String
        public let skuCatalog: String
        public let imageUrls: [String]
        public let localizedTitle: String
        public let localizedBrand: String
        public let localizedPrice: String
        public let localizedOldPrice: String?
        public let localizedDiscount: String?

        /// This structure represents the information about a SKU in the Aiuta platform.
        ///
        /// - Parameters:
        ///   - skuId: A unique identifier for the SKU.
        ///   - skuCatalog: The catalog identifier the SKU belongs to.
        ///                 See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference
        ///                 to learn how to find out the catalog name of your SKU.
        ///   - imageUrls: A list of URLs pointing to the images of the SKU.
        ///   - localizedTitle: The title of the SKU.
        ///   - localizedBrand: The brand of the SKU.
        ///   - localizedPrice: The price of the SKU.
        ///   - localizedOldPrice: The old price of the SKU, if available.
        ///   - localizedDiscount: The discount on the SKU, if available.
        public init(skuId: String,
                    skuCatalog: String,
                    imageUrls: [String],
                    localizedTitle: String,
                    localizedBrand: String,
                    localizedPrice: String,
                    localizedOldPrice: String? = nil,
                    localizedDiscount: String? = nil) {
            self.skuId = skuId
            self.skuCatalog = skuCatalog
            self.imageUrls = imageUrls
            self.localizedTitle = localizedTitle
            self.localizedBrand = localizedBrand
            self.localizedPrice = localizedPrice
            self.localizedOldPrice = localizedOldPrice
            self.localizedDiscount = localizedDiscount
        }
    }

    /// This function configures the Aiuta SDK with the necessary API key and sets up the required services.
    /// You can call this method as many times as you like to update the configuration.
    ///
    /// - Parameters:
    ///   - apiKey: The API key provided by Aiuta for accessing its services.
    ///             See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
    ///             See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.
    ///   - configuration: Aiuta SDK Configuration struct.
    @available(iOS 13.0.0, *)
    public static func setup(apiKey: String, configuration: Aiuta.Configuration = .default) {
        trace(isEnabled: configuration.behavior.isDebugLogsEnabled)
        ResolverScope.cached.reset()
        Resolver.register { configuration }.scope(.cached)
        Resolver.register { ApiService(baseUrl: "https://api.aiuta.com", apiKey: apiKey) }.scope(.cached)
        Resolver.register { AiutaSdkDesignSystem(configuration.appearance) }.implements(DesignSystem.self).scope(.cached)
        Resolver.register { AiutaSdkModelImpl() }.implements(AiutaSdkModel.self).scope(.cached)
    }

    /// This function presents a UI component that allows users to virtually try on a SKU or related SKUs.
    ///
    /// - Parameters:
    ///   - sku: The primary SKU that users will try on.
    ///   - withMoreToTryOn: Related SKUs that the user can try on, defaulting to an empty array.
    ///   - in: The view controller from which the Aiuta UI will be presented.
    ///   - delegate: The delegate that will receive callbacks from the Aiuta SDK.
    @available(iOS 13.0.0, *)
    public static func tryOn(sku: SkuInfo,
                             withMoreToTryOn relatedSkus: [SkuInfo] = [],
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        let session = Aiuta.TryOnSession(tryOnSku: sku, moreToTryOn: relatedSkus, delegate: delegate)
        let startVc: UIViewController
        let tryOnVc = AiutaTryOnViewController(session: session)
        if tryOnVc.hasUploads { startVc = tryOnVc }
        else { startVc = AiutaOnboardingViewController(forward: tryOnVc) }
        startVc.hero.modalAnimationType = .selectBy(presenting: .push(direction: .left),
                                                    dismissing: .pull(direction: .right))
        viewController.present(startVc, animated: true)
    }
}

/// This protocol defines the delegate methods for receiving callbacks from the Aiuta SDK.
public protocol AiutaSdkDelegate: AnyObject {
    /// Called when a user selects to add an SKU to their wishlist.
    func aiuta(addToWishlist skuId: String)

    /// Called when a user selects to add an SKU to their cart.
    func aiuta(addToCart skuId: String)

    /// Called when a user selects to view more details about an SKU.
    func aiuta(showSku skuId: String)
}
