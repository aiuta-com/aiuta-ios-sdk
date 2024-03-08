# Aiuta Digital Try On SDK

This repo distributes the [Aiuta Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) library via Swift Package Manager.

## Installation

### Swift Package Manager

A AiutaSdk as a dependency the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/aiuta-com/aiuta-ios-sdk.git", branch: "main")
]
```

Add dependency to your target
```swift
    .product(name: "AiutaSdk", package: "aiuta-ios-sdk")
```

## Methods

### `Aiuta.setup(apiKey:configuration:)`

This function configures the Aiuta SDK with the necessary API key and sets up the required services.

See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.

#### Parameters

- `apiKey: String`: The API key provided by Aiuta for accessing its services.
- `configuration: Aiuta.Configuration`: Custom SDK configurations.

### `Aiuta.tryOn(sku:withMoreToTryOn:in:delegate:)`

This function presents a UI component that allows users to virtually try on a SKU or related SKUs.

#### Parameters

- `sku: SkuInfo`: The primary SKU that users will try on.
- `withMoreToTryOn relatedSkus: [SkuInfo]`: Related SKUs that the user can try on, defaulting to an empty array.
- `in viewController: UIViewController`: The view controller from which the Aiuta UI will be presented.
- `delegate: AiutaSdkDelegate`: The delegate that will receive callbacks from the Aiuta SDK.


## Structures

### `Aiuta.Configuration`

This structure provides customizable configurations for the Aiuta SDK, allowing you to tailor the SDK to your needs. All parameters are optional.

#### Substructures

- `Appearance`: Customizes the look and feel of the SDK's UI components.
- `Behavior`: Adjusts the SDK's behavior, such as the photo selection limit and debug log output.

##### `Appearance` Properties

- `brandColor: UIColor?`: Your brand's primary color, used for significant interface elements like the main action button and progress bars.
- `accentColor: UIColor?`: An extra special attention color for elements like discounted price labels and discount percentage backgrounds.
- `backgroundTint: UIColor?`: The background tint color for all screens, which will be diluted by an extraLight UIBlurEffect.

##### `Appearance.NavigationBar` Properties

- `logoImage: UIImage?`: A small image of your logo to display in the navigation bar.
- `foregroundColor: UIColor?`: The color of navigation bar elements where the logo isn't displayed, such as back and action buttons or screen headers.

##### `Behavior` Properties

- `photoSelectionLimit: Int`: The maximum number of photos a user can select for virtual try-on, defaulting to 10.
- `isDebugLogsEnabled: Bool`: Controls the output of SDK debug logs, defaulting to false.

### `Aiuta.SkuInfo`

This structure represents the information about a SKU in the Aiuta platform.

#### Properties

- `skuId: String`: A unique identifier for the SKU.
- `skuCatalog: String`: The catalog identifier the SKU belongs to.
- `imageUrls: [String]`: A list of URLs pointing to the images of the SKU.
- `localizedTitle: String`: The title of the SKU.
- `localizedBrand: String`: The brand of the SKU.
- `localizedPrice: String`: The price of the SKU.
- `localizedOldPrice: String?`: The old price of the SKU, if available.
- `localizedDiscount: String?`: The discount on the SKU, if available.


## Protocols

### `AiutaSdkDelegate`

This protocol defines the delegate methods for receiving callbacks from the Aiuta SDK.

#### Methods

- `aiuta(addToWishlist skuId: String)`: Called when a user adds an SKU to their wishlist.
- `aiuta(addToCart skuId: String)`: Called when a user adds an SKU to their cart.
- `aiuta(showSku skuId: String)`: Called when a user selects to view more details about an SKU.

## Example Usage

```swift
// Setup the Aiuta SDK with your API key and custom configuration
if #available(iOS 13.0.0, *) {
    var configuration = Aiuta.Configuration()
    configuration.appearance.brandColor = .red
    configuration.appearance.accentColor = .green
    configuration.appearance.navigationBar.logoImage = UIImage(named: "your_logo")
    configuration.behavior.photoSelectionLimit = 4
    
    Aiuta.setup(apiKey: "your_api_key", configuration: configuration)
}

// Define a delegate for handling Aiuta SDK callbacks
class MyAiutaDelegate: AiutaSdkDelegate {
    func aiuta(addToWishlist skuId: String) {
        print("Add to wishlist: \(skuId)")
    }

    func aiuta(addToCart skuId: String) {
        print("Add to cart: \(skuId)")
    }

    func aiuta(showSku skuId: String) {
        print("Show SKU details: \(skuId)")
    }
}

// Use Aiuta's try-on feature in your view controller
class MyViewController: UIViewController {
    let delegate = MyAiutaDelegate()

    func tryOnFeature() {
        let sku = Aiuta.SkuInfo(skuId: "123", skuCatalog: "catalog1", imageUrls: ["url1", "url2"], localizedTitle: "Title", localizedBrand: "Brand", localizedPrice: "$12.99")
        if #available(iOS 13.0.0, *) {
            Aiuta.tryOn(sku: sku, in: self, delegate: delegate)
        }
    }
}
```

This documentation provides a concise overview of the Aiuta Swift SDK's core functionalities, allowing developers to integrate Aiuta's features into their iOS applications effectively.
