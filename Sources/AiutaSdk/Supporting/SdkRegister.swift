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
import Alamofire
import Resolver
import UIKit

final class SdkRegister {
    @available(iOS 13.0.0, *)
    static func setup(apiKey: String, configuration: Aiuta.Configuration?) {
        instance.setup(apiKey: apiKey, configuration: configuration)
    }

    static func insureConfigured() -> Bool {
        VanilaHero.capture()
        return instance.isConfigured
    }

    fileprivate static var instance = SdkRegister()
    private init() {}

    private var isConfigured = false
    private let scope = ResolverScopeCache()
    fileprivate let resolver = Resolver()

    @available(iOS 13.0.0, *)
    private func setup(apiKey: String, configuration: Aiuta.Configuration?) {
        checkIfUsageDescriptionsProvided()

        let config = configuration ?? .default
        trace(isEnabled: config.behavior.isDebugLogsEnabled)
        setLocalization(language: config.appearance.language)
        setDefaults(apiKey: apiKey)
        scope.reset()

        AiutaKit.register(
            ds: { AiutaSdkDesignSystem(config) },
            heroic: { VanilaHero.capture() },
            imageTraits: { SdkImageTraits() }
        )

        resolver.register { config }.scope(scope)
        resolver.register { RestService(SdkApiProvider(apiKey: apiKey)) }.implements(ApiService.self).scope(scope)
        resolver.register { SdkWatermarker(config.behavior.watermark) }.implements(Watermarker.self).scope(scope)
        resolver.register { SdkAnalyticsEnvImpl() }.implements(SdkAnalyticsEnv.self).scope(scope)
        resolver.register { AnalyticRouter(.ordinary(SdkAnalyticsTarget(apiKey))) }.implements(AnalyticTracker.self).scope(scope)
        resolver.register { AiutaSubscriptionImpl() }.implements(AiutaSubscription.self).scope(scope)
        resolver.register { AiutaSdkModelImpl() }.implements(AiutaSdkModel.self).scope(scope)

        @injected var tracker: AnalyticTracker
        tracker.track(.session(.configure(hasCustomConfiguration: configuration.isSome, configuration: config)))

        @injected var subscription: AiutaSubscription
        subscription.load()

        @injected var model: AiutaSdkModel
        model.eraseHistoryIfNeeded()

        isConfigured = true
    }

    private func checkIfUsageDescriptionsProvided() {
        @bundle(key: "NSCameraUsageDescription")
        var cameraUsageDescription: String?

        if cameraUsageDescription.isNullOrEmpty {
            fatalError("Please provide NSCameraUsageDescription in your Info.plist so that Aiuta can request permission to use the camera from the user.")
        }

        @bundle(key: "NSPhotoLibraryAddUsageDescription")
        var photoLibraryAddUsageDescription: String?

        if photoLibraryAddUsageDescription.isNullOrEmpty {
            NSLog("Please provide NSPhotoLibraryAddUsageDescription in your Info.plist so that Aiuta can request permission to save the generated image to the Photo Gallery from the user.")
        }
    }
}

@propertyWrapper struct injected<Service> {
    var wrappedValue: Service = SdkRegister.instance.resolver.resolve(Service.self)
}
