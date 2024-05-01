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

@propertyWrapper 
@_spi(Aiuta) public struct bundle<Value> {
    public private(set) var wrappedValue: Value

    public init(key: String, atPath path: String? = nil, inBundle bundle: Bundle = .main) {
        if let path {
            let bundleInfo = bundle.infoDictionary?[path] as! [String: Any]
            wrappedValue = bundleInfo[key] as! Value
        } else {
            wrappedValue = bundle.infoDictionary?[key] as! Value
        }
    }

    public init(resource: String, ofType type: String, atPath path: String, inBundle bundle: Bundle = .main) {
        let bundleInfo = bundle.infoDictionary?[path] as! [String: Any]
        let resourcePath = bundleInfo[resource] as! String
        wrappedValue = bundle.path(forResource: resourcePath, ofType: type) as! Value
    }

    public init(resource: String, ofType type: String, inBundle bundle: Bundle = .main) {
        wrappedValue = bundle.path(forResource: resource, ofType: type) as! Value
    }
}
