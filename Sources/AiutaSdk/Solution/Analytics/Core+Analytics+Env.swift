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
import Foundation

extension Sdk.Core.Analytics {
    protocol Env {
        var hostId: String? { get }
        var hostVersion: String { get }
        var installationId: String { get }
    }
}

extension Sdk.Core.Analytics {
    struct EnvImpl: Env {
        let hostId: String?
        let hostVersion: String
        let installationId: String

        init() {
            hostId = Bundle.main.bundleIdentifier

            @bundle(key: "CFBundleShortVersionString")
            var bundleVersion: String
            hostVersion = bundleVersion

            @defaults(key: "aiutaSdkInstallationId", defaultValue: nil)
            var installationId: String?
            if let installationId {
                self.installationId = installationId
            } else {
                let uuid = UUID().uuidString
                installationId = uuid
                self.installationId = uuid
            }
        }
    }
}
