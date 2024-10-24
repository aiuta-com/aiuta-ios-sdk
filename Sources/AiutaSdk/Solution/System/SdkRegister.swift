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
    static func setup(auth: Aiuta.AuthType, configuration: Aiuta.Configuration?, controller: AiutaDataController?) {
        instance.setup(auth: auth, configuration: configuration, controller: controller)
    }

    static func ensureConfigured() -> Bool {
        return instance.isConfigured
    }

    fileprivate static var instance = SdkRegister()
    private init() {}

    private var isConfigured = false
    private let scope = ResolverScopeCache()
    fileprivate let resolver = Resolver()

    @available(iOS 13.0.0, *)
    private func setup(auth: Aiuta.AuthType, configuration: Aiuta.Configuration?, controller: AiutaDataController?) {
        checkIfUsageDescriptionsProvided()

        let config = configuration ?? .default
        let isDebug = config.behavior.isDebugLogsEnabled

        trace(isEnabled: isDebug)
        setLocalization(config.appearance.localization)
        setDefaults(apiKey: auth.keyToDefaults)
        scope.reset()

        AiutaKit.register(
            ds: { SdkTheme(config) },
            imageTraits: { SdkImageTraits() }
        )

        resolver.register { config }.scope(scope)
        resolver.register { RestService(SdkApiProvider(auth: auth), debugger: ApiDebuggerImpl(isEnabled: isDebug)) }.implements(ApiService.self).scope(scope)
        resolver.register { SdkWatermarker(config.behavior.watermark) }.implements(Watermarker.self).scope(scope)
        resolver.register { SdkAnalyticsEnvImpl() }.implements(SdkAnalyticsEnv.self).scope(scope)
        resolver.register { AnalyticRouter(.ordinary(SdkAnalyticsTarget(auth, logging: isDebug))) }.implements(AnalyticTracker.self).scope(scope)

        resolver.register { SessionModelImpl() }.implements(SessionModel.self).scope(scope)
        resolver.register { ConsentModelImpl() }.implements(ConsentModel.self).scope(scope)
        resolver.register { HistoryModelImpl() }.implements(HistoryModel.self).scope(scope)
        resolver.register { TryOnModelImpl() }.implements(TryOnModel.self).scope(scope)
        resolver.register { SubscriptionModelImpl() }.implements(SubscriptionModel.self).scope(scope)

        if let controller {
            controller.setData(provider: DataProviderImpl(delegate: controller))
        }

        @injected var tracker: AnalyticTracker
        tracker.track(.session(.configure(hasCustomConfiguration: configuration.isSome, configuration: config)))

        @injected var subscription: SubscriptionModel
        subscription.load()

        isConfigured = true
    }

    private func checkIfUsageDescriptionsProvided() {
        @bundle(key: "NSCameraUsageDescription")
        var cameraUsageDescription: String?

        if cameraUsageDescription.isNullOrEmpty {
            NSLog("Please provide NSCameraUsageDescription in your Info.plist so that Aiuta can request permission to use the camera from the user.")
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

@available(iOS 13.0.0, *)
private struct ApiDebuggerImpl: ApiDebugger {
    var isEnabled: Bool

    func startOperation(id: String?, title: String, subtitle: String?) async -> ApiDebuggerOperation? { nil }
}

@available(iOS 13.0.0, *)
private extension Aiuta.AuthType {
    var keyToDefaults: String {
        switch self {
            case let .apiKey(apiKey): return apiKey
            case let .jwt(subscriptionId, _): return subscriptionId
        }
    }
}
