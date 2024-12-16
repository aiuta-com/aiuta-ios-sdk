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
final class SdkAnalyticsTarget: AnalyticTarget {
    private let api: ApiService
    private let logsEnabled: Bool

    init(_ auth: Aiuta.AuthType, logging: Bool = false) {
        api = RestService(SdkApiProvider(
            auth: auth,
            baseUrl: "https://api.aiuta.com/analytics/v1",
            keyCodingStrategy: .useDefaultKeys
        ), debugger: SdkAnalyticsDebuggerImpl())
        logsEnabled = logging
    }

    func eventOccured(_ event: AnalyticEvent) {
        let dto = SdkAnalyticDto(event)
        Task { let _: SdkAnalyticResponse? = try? await api.request(dto) }
        guard logsEnabled, let data = try? JSONEncoder().encode(dto) else { return }
        trace(event.name, "\n\n\(String(decoding: data, as: UTF8.self))\n")
    }
}

@available(iOS 13.0.0, *)
private struct SdkAnalyticsDebuggerImpl: ApiDebugger {
    let isEnabled: Bool = false
    func startOperation(id: String?, title: String, subtitle: String?) async -> ApiDebuggerOperation? { nil }
}
