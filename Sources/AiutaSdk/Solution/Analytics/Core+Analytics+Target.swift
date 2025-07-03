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
import Foundation

@available(iOS 13.0.0, *)
extension Sdk.Core.Analytics {
    final class Target: AnalyticTarget {
        private let api: ApiService

        init(_ auth: Aiuta.Auth,
             baseUrl: String = "https://api.aiuta.com/analytics/v1",
             keyCodingStrategy: ApiCodingStrategy = .useDefaultKeys) {
            api = RestService(Sdk.Core.Api.Provider(
                auth: auth,
                baseUrl: baseUrl,
                keyCodingStrategy: keyCodingStrategy
            ), debugger: Debugger())
        }

        func eventOccured(_ event: AnalyticEvent) {
            Task { await postEvent(event) }
        }

        @discardableResult
        func postEvent(_ event: AnalyticEvent) async -> Response? {
            try? await api.request(Post(event))
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Core.Analytics {
    struct Debugger: ApiDebugger {
        let isEnabled: Bool = false
        func startOperation(id: String?,
                            title: String,
                            subtitle: String?
        ) async -> ApiDebuggerOperation? { nil }
    }
}

extension AnalyticTracker {
    func track(_ event: Aiuta.Event) {
        @injected var config: Sdk.Configuration
        track(AnalyticEvent(event.name(), event.parameters()))
        if config.settings.isLoggingEnabled, let data = try? JSONEncoder().encode(event) {
            trace(i: "○", event.rawQualifier, "\n\n\(String(decoding: data, as: UTF8.self))\n")
        }
        guard #available(iOS 13.0, *),
              let handler = config.features.analytics.handler else { return }
        Task { await handler.onAnalyticsEvent(event) }
    }
}
