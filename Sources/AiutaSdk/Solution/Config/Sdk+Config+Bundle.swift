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

extension UIImage {
    static let sdkBundle: Bundle? = {
        let bundleName = "AiutaSdk_AiutaSdk"
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: Sdk.Register.self).resourceURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent("\(bundleName).bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) { return bundle }
        }

        return Bundle(for: Sdk.Register.self)
    }()
}

extension UIImage {
    static func bundleImage(_ name: String) -> UIImage? {
        UIImage(named: name, in: UIImage.sdkBundle, compatibleWith: nil)
    }
}
