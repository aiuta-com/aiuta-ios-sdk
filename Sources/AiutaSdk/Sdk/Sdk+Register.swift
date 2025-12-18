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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import Alamofire
import Resolver
import UIKit

extension Sdk {
    final class Register {
        @available(iOS 13.0.0, *)
        static func setup(configuration: Aiuta.Configuration) {
            instance.setup(configuration)
        }

        static func ensureConfigured() -> Bool {
            return instance.isConfigured
        }

        fileprivate static let instance = Register()
        fileprivate let resolver = Resolver()

        private let scope = ResolverScopeCache()
        private var isConfigured = false

        @available(iOS 13.0.0, *)
        private func setup(_ configuration: Aiuta.Configuration) {
            setDefaults(apiKey: configuration.keyToDefaults)

            let config = Configuration(configuration)
            let isDebug = config.settings.isLoggingEnabled

            trace(isEnabled: isDebug)
            scope.reset()

            AiutaKit.register(
                ds: { Theme(config) },
                imageTraits: { Configuration.Images.Traits() },
            )

            resolver.register {
                config
            }.scope(scope)

            resolver.register {
                RestService(Core.Api.Provider(auth: config.auth.type),
                            debugger: Core.Api.Debugger(isEnabled: isDebug))
            }.implements(ApiService.self).scope(scope)

            resolver.register {
                Configuration.Images.Watermarker(config.images)
            }.implements(Watermarker.self).scope(scope)

            resolver.register {
                Core.Analytics.EnvImpl()
            }.implements(Core.Analytics.Env.self).scope(scope)

            resolver.register {
                AnalyticRouter(.ordinary(Core.Analytics.Target(config.auth.type)))
            }.implements(AnalyticTracker.self).scope(scope)

            resolver.register { Core.OnboardingImpl() }.implements(Core.Onboarding.self).scope(scope)
            resolver.register { Core.SubscriptionImpl() }.implements(Core.Subscription.self).scope(scope)
            resolver.register { Core.ModelsImpl() }.implements(Core.Models.self).scope(scope)
            resolver.register { Core.SessionImpl() }.implements(Core.Session.self).scope(scope)
            resolver.register { Core.ConsentImpl() }.implements(Core.Consent.self).scope(scope)
            resolver.register { Core.HistoryImpl() }.implements(Core.History.self).scope(scope)
            resolver.register { Core.TryOnImpl() }.implements(Core.TryOn.self).scope(scope)
            resolver.register { Core.WishlistImpl() }.implements(Core.Wishlist.self).scope(scope)
            resolver.register { Core.SizeFitImpl() }.implements(Core.SizeFit.self).scope(scope)

            @injected var tracker: AnalyticTracker
            tracker.track(.configure)

            @injected var subscription: Core.Subscription
            subscription.load()

            @injected var models: Core.Models
            models.load()

            isConfigured = true
        }

        private init() {}
    }
}

// MARK: - SDK Services Dependency Injection

@propertyWrapper struct injected<Service> {
    var wrappedValue: Service = Sdk.Register.instance.resolver.resolve(Service.self)
}
