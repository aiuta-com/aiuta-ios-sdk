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

public enum Aiuta {
    /// Aiuta SDK Version
    public static let sdkVersion = "1.1.4"

    /// This function configures the Aiuta SDK with the necessary API key and sets up the required services.
    /// You can call this method as many times as you like to update the configuration.
    ///
    /// - Parameters:
    ///   - apiKey: The API key provided by Aiuta for accessing its services.
    ///             See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
    ///             See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.
    ///   - configuration: Aiuta SDK Configuration struct, see Aiuta.Configuration down below.
    @available(iOS 13.0.0, *)
    public static func setup(apiKey: String, configuration: Aiuta.Configuration?) {
        SdkRegister.setup(apiKey: apiKey, configuration: configuration)
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
        SdkPresenter.tryOn(sku: sku, withMoreToTryOn: relatedSkus, in: viewController, delegate: delegate)
    }

    /// This function presents a UI component that allows the user to view the history of his virtuall try ons.
    ///
    /// - Parameters:
    ///   - in: The view controller from which the Aiuta UI will be presented.
    @available(iOS 13.0.0, *)
    @discardableResult
    public static func showHistory(in viewController: UIViewController) -> Bool {
        SdkPresenter.showHistory(in: viewController)
    }
}

// MARK: - Configuration

extension Aiuta {
    /// Aiuta SDK Configuration.
    /// All parameters are optional, you can only change the parts you are interested in.
    public struct Configuration {
        public static let `default` = Configuration()

        public enum Language {
            case English, Turkish, Russian
        }

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

            /// Controls whether the Power by Aiuta link is displayed during the generation process.
            @available(*, deprecated, message: "Resolves automatically, this setting is ignored.")
            public var showPoweredByLink = false

            /// The language in which the SDK interface will be displayed.
            /// If not specified, the first preferred system language will be used
            /// if it is supported, otherwise English will be used.
            public var language: Language?
        }

        public struct Behavior {
            /// The maximum number of photos that a user can select
            /// in the system piker for virtual try on.
            public var photoSelectionLimit: Int = 10

            /// Controls the availability of generation history to the user.
            /// When disabled the history will not be collected,
            /// the history screen will not be available and
            /// all previous generation history will be deleted.
            public var isHistoryAvailable: Bool = true

            /// Controls the availability of the add to wishlist button when viewing SKU information.
            public var isWishlistAvailable: Bool = true

            public struct Watermark {
                /// Optional watermark image that will be applied to share generated image.
                /// Watermark will fit within the (x: 0.5, y: 0.82, w: 0.45, h: 0.14) area of the generated image,
                /// but not exceeding the original size multiplied by the scale, aligned to the bottom-right corner of area.
                public var image: UIImage? = nil
            }

            /// Watermark configuration.
            /// Defined as structure for possible further extension of the watermark placement.
            public var watermark = Watermark()

            /// Controls the output of SDK debug logs.
            public var isDebugLogsEnabled: Bool = false
        }

        /// UI configuration.
        public var appearance = Appearance()

        /// Behavior configuration.
        public var behavior = Behavior()

        public init() {}
    }
}

// MARK: - SKU

extension Aiuta {
    /// This structure represents the information about a SKU in the Aiuta platform.
    public struct SkuInfo {
        public let skuId: String
        public let skuCatalog: String?
        public let imageUrls: [String]
        public let localizedTitle: String
        public let localizedBrand: String
        public let localizedPrice: String
        public let localizedOldPrice: String?
        public let localizedDiscount: String?
        public let additionalShareInfo: String?

        /// - Parameters:
        ///   - skuId: A unique identifier for the SKU.
        ///   - skuCatalog: The catalog identifier the SKU belongs to.
        ///                 See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference
        ///                 to learn how to find out the catalog name of your SKU.
        ///
        ///                 **Since SDK version 1.1.3 this parameter is optional.**
        ///                 *If not specified the default catalog will be used.*
        ///                 ** (!) It is recommended not to specify a skuCatalog unless it is explicitly necessary.**
        ///
        ///   - imageUrls: A list of URLs pointing to the images of the SKU.
        ///   - localizedTitle: The title of the SKU.
        ///   - localizedBrand: The brand of the SKU.
        ///   - localizedPrice: The price of the SKU. Should be formatted with a currency symbol.
        ///   - localizedOldPrice: The old price of the SKU, if available. Should be formatted with a currency symbol.
        ///   - localizedDiscount: The discount on the SKU, if available. Should be formatted with a percent symbol.
        ///   - additionalShareInfo: Additional information that will be passed to the share along with the generated image.
        ///                          *(!) Some applications do not accept image and text/url for publishing.*
        ///                          *As we find out, such apps will be blacklisted in the next SDK updates.*
        ///                          *Only the image is sent to apps on this list.*
        public init(skuId: String,
                    skuCatalog: String? = nil,
                    imageUrls: [String],
                    localizedTitle: String,
                    localizedBrand: String,
                    localizedPrice: String,
                    localizedOldPrice: String? = nil,
                    localizedDiscount: String? = nil,
                    additionalShareInfo: String? = nil) {
            self.skuId = skuId
            self.skuCatalog = skuCatalog
            self.imageUrls = imageUrls
            self.localizedTitle = localizedTitle
            self.localizedBrand = localizedBrand
            self.localizedPrice = localizedPrice
            self.localizedOldPrice = localizedOldPrice
            self.localizedDiscount = localizedDiscount
            self.additionalShareInfo = additionalShareInfo
        }
    }
}

// MARK: - Events

extension Aiuta {
    /// A significant event occurring in the SDK
    /// that an host application can send to its own analytics.
    public enum SdkEvent {
        /// The user has finished onboarding.
        case onBoardingCompleted
        /// The user took a new photo to try-on with the camera.
        case newPhotoTaken
        /// The user has selected `photosCount` photos to try-on from the phone gallery.
        case galleryPhotosSelected(photosCount: Int)
        /// Try-on of `skuId` started with `photosCount` user photos in parallel.
        case tryOnStarted(skuId: String, photosCount: Int)
        /// The result of the generation is shown to the user.
        case tryOnResultShown(skuId: String)
        /// The user opened the generation history screen.
        case historyScreenOpened
        /// User shared `photosCount` generated images
        case shareGeneratedImages(photosCount: Int)
    }
}

// MARK: - Delegate

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
    func aiuta(eventOccurred event: Aiuta.SdkEvent)
}

public extension AiutaSdkDelegate {
    /// Making this delegate method optional with warning.
    func aiuta(eventOccurred event: Aiuta.SdkEvent) {
        print("(i) AiutaSDK: Implement aiuta(eventOccurred:) in your AiutaSdkDelegate to remove this warning and track `\(event)` event.")
    }
}
