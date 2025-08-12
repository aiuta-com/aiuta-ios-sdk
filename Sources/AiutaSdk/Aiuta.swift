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

/// Aiuta Virtual Try-On SDK public namespace & entry point.
/// Full documentation is available at https://docs.aiuta.com
/// More specific documentation for the iOS SDK is available
/// at https://docs.aiuta.com/sdk/ios/
public enum Aiuta { }

// MARK: - Configuration

/// Set of methods to configure the Aiuta SDK.
@available(iOS 13.0.0, *)
@MainActor public extension Aiuta {
    /// Configures the SDK and sets up the required services.
    /// You can call this method multiple times to update the configuration.
    ///
    /// Read more at https://docs.aiuta.com/sdk/ios/configuration/
    ///
    /// - Parameters:
    ///   - configuration: Aiuta SDK Configuration.
    ///
    /// - Note: See https://docs.aiuta.com/sdk/ios/quick-test/ for a quick testing SDK
    /// integration with test `apiKey` auth and sample product data.
    static func setup(configuration: Configuration) {
        Sdk.Register.setup(configuration: configuration)
    }
}

// MARK: - Usage

/// Set of methods to present the Aiuta SDK UI components for virtual try-on.
@available(iOS 13.0.0, *)
@MainActor public extension Aiuta {
    /// Presents a UI component that allows users to virtually try on a single product.
    /// Find more about general SDK usage at https://docs.aiuta.com/sdk/ios/basic-usage/
    ///
    /// - Parameters:
    ///   - product: The `Product` that users will try on.
    ///
    /// Please refer to the [Product sheme](https://docs.aiuta.com/sdk/developer/product/)
    /// for more details on how to pass the product to the SDK.
    static func tryOn(product: Product) async {
        await Sdk.Presenter.tryOn(product: product)
    }
}

/// Set of methods to present the Aiuta SDK UI components for virtual try-on history
/// and direct access to the Aiuta virtual try-on history to be embedded in the app.
@available(iOS 13.0.0, *)
@MainActor public extension Aiuta {
    /// Presents a UI component that allows users to view the history of their virtual try-ons.
    /// Find more about general SDK usage at https://docs.aiuta.com/sdk/ios/basic-usage/
    @discardableResult
    static func showHistory() async -> Bool {
        await Sdk.Presenter.showHistory()
    }
}

// MARK: - State

/// Extension to check the current state of the Aiuta SDK.
public extension Aiuta {
    /// The current version of the SDK.
    static var sdkVersion: String {
        Sdk.version
    }

    /// Indicates whether the SDK is currently displayed in the foreground.
    @available(iOS 13.0.0, *)
    @MainActor static var isForeground: Bool {
        Sdk.isForeground
    }
}
