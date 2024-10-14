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
    public static let sdkVersion = "3.0.6"

    /// This function configures the Aiuta SDK with the necessary API key and sets up the required services.
    /// You can call this method as many times as you like to update the configuration.
    ///
    /// - Parameters:
    ///   - apiKey: The API key provided by Aiuta for accessing its services.
    ///             See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
    ///             See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.
    ///   - configuration: Aiuta SDK Configuration struct, see Aiuta.Configuration down below.
    @available(iOS 13.0.0, *)
    public static func setup(auth: AiutaAuthType, configuration: Aiuta.Configuration?) {
        SdkRegister.setup(auth: auth, configuration: configuration)
    }

    /// This function presents a UI component that allows users to virtually try on a SKU or related SKUs.
    ///
    /// - Parameters:
    ///   - sku: The primary SKU that users will try on.
    ///   - withMoreToTryOn: Related SKUs that the user can try on, defaulting to an empty array.
    ///   - in: The view controller from which the Aiuta UI will be presented.
    ///   - delegate: The delegate that will receive callbacks from the Aiuta SDK.
    @available(iOS 13.0.0, *)
    public static func tryOn(sku: Product,
                             withMoreToTryOn relatedSkus: [Product] = [],
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

// MARK: - Porduct / SKU

extension Aiuta {
    /// This structure represents the information about a SKU in the Aiuta platform.
    public struct Product {
        public let skuId: String
        public let skuCatalog: String?
        public let imageUrls: [String]
        public let localizedTitle: String
        public let localizedBrand: String
        public let localizedPrice: String?
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
                    localizedPrice: String? = nil,
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

    public typealias SkuInfo = Product
}

@available(iOS 13.0.0, *)
public enum AiutaAuthType {
    case apiKey(apiKey: String)
    case jwt(subscriptionId: String, jwtProvider: AiutaJwtProvider)
}

@available(iOS 13.0.0, *)
public protocol AiutaJwtProvider {
    func getJwt(requestParams: [String: String]) async throws -> String
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

// MARK: - Configuration

extension Aiuta {
    /// Aiuta SDK Configuration.
    /// All parameters are optional, you can only change the parts you are interested in.
    public struct Configuration {
        public static let `default` = Configuration()

        /// UI configuration.
        public var appearance = Appearance()

        /// Behavior configuration.
        public var behavior = Behavior()

        public init() {}
    }
}

extension Aiuta.Configuration {
    /// Various SDK behavior settings.
    public struct Behavior {
        /// Controls the availability of generation history to the user.
        /// When disabled the history will not be collected,
        /// the history screen will not be available and
        /// all previous generation history will be deleted.
        public var isHistoryAvailable: Bool = true

        /// Controls the availability of the add to wishlist button when viewing SKU information.
        public var isWishlistAvailable: Bool = true

        /// While waiting for the try-on result, try to highlight the human outline
        /// using iOS system tools on the animation screen . Works locally. iOS 15+.
        /// In case of failure, the normal animation of the loader will not be affected.
        public var tryGeneratePersonSegmentation: Bool = false

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
}

extension Aiuta.Configuration {
    /// Settings for how the SDK will be displayed.
    public struct Appearance {
        public var presentationStyle: PresentationStyle = .pageSheet
        public var extendedOnbordingNavBar: Bool = false
        public var preferRightClose: Bool = false
        public var reduceShadows: Bool = false

        /// The language in which the SDK interface will be displayed.
        /// If not specified, the first preferred system language will be used
        /// if it is supported, otherwise English will be used.
        public var language: Language?

        public var colors = Colors()
        public var dimensions = Dimensions()
        public var fonts = Fonts()
        public var images = Images()
    }
}

// MARK: - Appearance.Manguage

extension Aiuta.Configuration.Appearance {
    /// The language in which the SDK should be displayed.
    public enum Language: Equatable {
        case English, Turkish, Russian
    }
}

// MARK: - Appearance.PresentationStyle

extension Aiuta.Configuration.Appearance {
    /// Defines how the SDL will be presented as modal view controller.
    public enum PresentationStyle: Equatable, Codable {
        ///
        case pageSheet
        case bottomSheet
        case fullScreen
    }
}

// MARK: - Appearance.Color

extension Aiuta.Configuration.Appearance {
    public enum Style {
        case light, dark
    }

    /// Color overrides
    public struct Colors {
        public var style: Style = .light

        /// Your brand's primary color.
        /// This color will be used for all significant interface elements,
        /// such as the main action button on the screen, progress bars, etc.
        public var brand: UIColor?

        /// Extra special attention color. The discounted price labels
        /// and the discount percentage background will be colored in it.
        public var accent: UIColor?
        public var aiuta: UIColor?

        public var primary: UIColor?
        public var secondary: UIColor?
        public var tertiary: UIColor?
        public var onDark: UIColor?

        public var error: UIColor?
        public var onError: UIColor?

        /// The background color of all screens.
        public var background: UIColor?
        public var neutral: UIColor?
        public var neutral2: UIColor?
        public var neutral3: UIColor?

        public var green: UIColor?
        public var red: UIColor?
        public var gray: UIColor?
        public var lightGray: UIColor?
        public var darkGray: UIColor?

        public var loadingAnimation: [UIColor]?

        public init() {}
    }
}

// MARK: - Appearance.Dimesions

extension Aiuta.Configuration.Appearance {
    /// Varios corner radiuses, sizes, offsets, etc.
    public struct Dimensions {
        public var imageMainRadius: CGFloat?
        public var imageBoardingRadius: CGFloat?
        public var imagePreviewRadius: CGFloat?

        public var bottomSheetRadius: CGFloat?

        public var buttonLargeRadius: CGFloat?
        public var buttonSmallRadius: CGFloat?

        public var grabberWidth: CGFloat?
        public var grabberOffset: CGFloat?

        public var continuingSeparators: Bool?

        public init() {}
    }
}

// MARK: - Appearance.Fonts

extension Aiuta.Configuration.Appearance {
    /// Custom fonts
    public struct Fonts {
        public var titleXL: CustomFont?
        public var titleL: CustomFont?
        public var titleM: CustomFont?

        public var navBar: CustomFont?
        public var regular: CustomFont?
        public var button: CustomFont?
        public var buttonS: CustomFont?

        public var cells: CustomFont?
        public var chips: CustomFont?

        public var product: CustomFont?
        public var price: CustomFont?
        public var brand: CustomFont?

        public var description: CustomFont?

        public init() {}
    }

    public struct CustomFont {
        public let font: UIFont
        public let family: String
        public let size: CGFloat
        public let weight: UIFont.Weight
        public var kern: CGFloat?
        public var lineHeightMultiple: CGFloat?

        public init(font: UIFont, family: String, size: CGFloat, weight: UIFont.Weight, kern: CGFloat? = nil, lineHeightMultiple: CGFloat? = nil) {
            self.font = font
            self.family = family
            self.size = size
            self.weight = weight
            self.kern = kern
            self.lineHeightMultiple = lineHeightMultiple
        }
    }
}

// MARK: - Appearance.Images

extension Aiuta.Configuration.Appearance {
    /// Image overrides
    public struct Images {
        public var icons16 = Icons16()
        public var icons20 = Icons20()
        public var icons24 = Icons24()
        public var icons36 = Icons36()
        public var icons82 = Icons82()
        public var screens = Screens()

        public init() {}
    }
}

extension Aiuta.Configuration.Appearance.Images {
    public struct Icons16 {
        public var check: UIImage?
        public var magic: UIImage?
        public var lock: UIImage?
        public var arrow: UIImage?
        public var spin: UIImage?
    }

    public struct Icons20 {
        public var info: UIImage?
    }

    public struct Icons24 {
        public var back: UIImage?
        public var camera: UIImage?
        public var checkCorrect: UIImage?
        public var checkNotCorrect: UIImage?
        public var close: UIImage?
        public var trash: UIImage?
        public var takePhoto: UIImage?
        public var history: UIImage?
        public var photoLibrary: UIImage?
        public var share: UIImage?
        public var wishlist: UIImage?
        public var wishlistFill: UIImage?
    }

    public struct Icons36 {
        public var error: UIImage?
        public var like: UIImage?
        public var dislike: UIImage?
    }

    public struct Icons82 {
        public var splash: UIImage?
    }

    public struct Screens {
        public var splash: UIImage?
    }
}
