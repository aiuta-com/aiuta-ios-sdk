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

/// Aiuta SDK Virtual Try-On Solution for Apparel and Fashion Businesses.
/// This enum provides the namespaced entry point for configuring and using the Aiuta SDK.
public enum Aiuta { }

// MARK: - Configuration

/// Set of methods to configure the Aiuta SDK.
@available(iOS 13.0.0, *)
@MainActor extension Aiuta {
    /// Configures the SDK and sets up the required services.
    /// You can call this method multiple times to update the configuration.
    ///
    /// - Parameters:
    ///   - configuration: Aiuta SDK Configuration.
    public static func setup(configuration: Configuration) {
        Sdk.Register.setup(configuration: configuration)
    }
}

// MARK: - Usage

/// Set of methods to present the Aiuta SDK UI components for virtual try-on.
@available(iOS 13.0.0, *)
@MainActor extension Aiuta {
    /// Presents a UI component that allows users to virtually try on a single product.
    ///
    /// - Parameters:
    ///   - product: The `Product` that users will try on.
    ///   - in: The view controller from which the Aiuta UI will be presented.
    public static func tryOn(product: Product, in viewController: UIViewController) async {
        await Sdk.Presenter.tryOn(product: product, in: viewController)
    }
}

/// Set of methods to present the Aiuta SDK UI components for virtual try-on history
/// and direct access to the Aiuta virtual try-on history to be embedded in the app.
@available(iOS 13.0.0, *)
@MainActor extension Aiuta {
    /// Presents a UI component that allows users to view the history of their virtual try-ons.
    ///
    /// - Parameters:
    ///   - in: The view controller from which the Aiuta UI will be presented.
    @discardableResult
    public static func showHistory(in viewController: UIViewController) async -> Bool {
        await Sdk.Presenter.showHistory(in: viewController)
    }
}

// MARK: - State

/// Extension to check the current state of the Aiuta SDK.
extension Aiuta {
    /// The current version of the SDK.
    public static var sdkVersion: String {
        Sdk.version
    }

    /// Indicates whether the SDK is currently displayed in the foreground.
    @available(iOS 13.0.0, *)
    @MainActor public static var isForeground: Bool {
        Sdk.isForeground
    }
}
