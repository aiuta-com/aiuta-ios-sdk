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

final class SdkAnalyticsTarget: AnalyticTarget {
    private let api: ApiService
    private let logsEnabled: Bool
    private let maxRetryCount: Int

    init(_ apiKey: String, retryCount: Int = 5, logging: Bool = false) {
        api = RestService(SdkApiProvider(apiKey: apiKey, baseUrl: "https://api.aiuta.com/analytics/v1"))
        maxRetryCount = retryCount
        logsEnabled = logging
    }

    func eventOccured(_ event: AnalyticEvent) {
        let dto = SdkAnalyticDto(event)
        Task { await send(dto) }
        guard logsEnabled, let data = try? JSONEncoder().encode(dto) else { return }
        trace(event.name, "\n\n\(String(decoding: data, as: UTF8.self))\n")
    }

    func send(_ dto: SdkAnalyticDto, retry: Int = 0) async {
        do {
            let _: SdkAnalyticResponse = try await api.request(dto)
        } catch {
            let nextTry = retry + 1
            guard nextTry <= maxRetryCount else { return }
            await asleep(.custom(TimeInterval(nextTry)))
            await send(dto, retry: nextTry)
        }
    }
}
