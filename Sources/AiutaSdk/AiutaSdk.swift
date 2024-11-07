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
    public static let sdkVersion = "3.2.6"

    /// This function configures the Aiuta SDK with the necessary auth type and sets up the required services.
    /// You can call this method as many times as you like to update the configuration.
    ///
    /// - Parameters:
    ///   - apiKey: The API key provided by Aiuta for accessing its services.
    ///             See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
    ///             See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.
    ///   - configuration: Aiuta SDK Configuration struct.
    ///                    See `AiutaSdk+Configuration.swift`.
    ///   - controller: Overrides Aiuta default data provider.
    ///                 See `AiutaSdk+Data.swift`.
    @available(iOS 13.0.0, *)
    public static func setup(auth: Aiuta.AuthType,
                             configuration: Aiuta.Configuration? = nil,
                             controller: AiutaDataController? = nil) {
        SdkRegister.setup(auth: auth, configuration: configuration, controller: controller)
    }

    /// This function presents a UI component that allows users to virtually try on a SKU or related SKUs.
    ///
    /// - Parameters:
    ///   - sku: The primary SKU that users will try on.
    ///   - in: The view controller from which the Aiuta UI will be presented.
    ///   - delegate: The delegate that will receive callbacks from the Aiuta SDK.
    ///               See `AiutaSdk+Delegate.swift`.
    @available(iOS 13.0.0, *)
    public static func tryOn(sku: Aiuta.Product,
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        SdkPresenter.tryOn(sku: sku, in: viewController, delegate: delegate)
    }

    /// This function presents a UI component that allows the user to view the history of his virtuall try ons.
    ///
    /// - Parameters:
    ///   - in: The view controller from which the Aiuta UI will be presented.
    ///   - delegate: The delegate that will receive callbacks from the Aiuta SDK.
    ///               See `AiutaSdk+Delegate.swift`.
    @available(iOS 13.0.0, *)
    @discardableResult
    public static func showHistory(in viewController: UIViewController,
                                   delegate: AiutaSdkDelegate) -> Bool {
        SdkPresenter.showHistory(in: viewController, delegate: delegate)
    }
}
