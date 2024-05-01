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

import Foundation

@_spi(Aiuta) open class AnalyticEvent {
    public enum Level: Comparable {
        case ordinary
        case significant
    }

    public let name: String
    public let timestamp = Date()
    public let parameters: [String: Any]?

    let level: Level

    public init(_ name: String, _ parameters: [String: Any]? = nil, level: Level = .ordinary) {
        self.name = name
        self.parameters = parameters
        self.level = level
    }
}
