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

struct SdkAnalyticDto: Encodable, ApiRequest {
    var urlPath: String { "ios-sdk-analytics" }
    var method: HTTPMethod { .post }

    struct Event: Encodable {
        let name: String
        let parameters: [String: Any]?

        enum CodingKeys: String, CodingKey {
            case name
            case parameters
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(name, forKey: .name)
            try container.encodeIfPresent(parameters, forKey: .parameters)
        }
    }

    struct Env: Encodable {
        let platform = "ios"
        let sdkVersion = Aiuta.sdkVersion
        let hostId = Bundle.main.bundleIdentifier
        let hostVersion: String

        init() {
            @bundle(key: "CFBundleShortVersionString")
            var bundleVersion: String
            hostVersion = bundleVersion
        }
    }

    let env = Env()
    let event: Event
    let localDateTime: String

    init(_ event: AnalyticEvent) {
        self.event = Event(name: event.name, parameters: event.parameters)
        if #available(iOS 15.0, *) {
            localDateTime = event.timestamp.ISO8601Format(.init(includingFractionalSeconds: true,
                                                                timeZone: .current))
        } else {
            let formater = ISO8601DateFormatter()
            formater.timeZone = .current
            formater.formatOptions = [.withFullDate,
                                      .withFullTime,
                                      .withFractionalSeconds,
                                      .withTimeZone]
            localDateTime = formater.string(from: event.timestamp)
        }
    }
}

struct SdkAnalyticResponse: Codable {
    let message: String
}
