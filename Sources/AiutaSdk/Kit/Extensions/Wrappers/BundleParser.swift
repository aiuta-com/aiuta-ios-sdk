//
//  Created by nGrey on 03.05.2023.
//

import Foundation

@propertyWrapper struct bundle<Value> {
    private(set) var wrappedValue: Value

    init(key: String, atPath path: String? = nil, inBundle bundle: Bundle = .main) {
        if let path {
            let bundleInfo = bundle.infoDictionary?[path] as! [String: Any]
            wrappedValue = bundleInfo[key] as! Value
        } else {
            wrappedValue = bundle.infoDictionary?[key] as! Value
        }
    }

    init(resource: String, ofType type: String, atPath path: String, inBundle bundle: Bundle = .main) {
        let bundleInfo = bundle.infoDictionary?[path] as! [String: Any]
        let resourcePath = bundleInfo[resource] as! String
        wrappedValue = bundle.path(forResource: resourcePath, ofType: type) as! Value
    }

    init(resource: String, ofType type: String, inBundle bundle: Bundle = .main) {
        wrappedValue = bundle.path(forResource: resource, ofType: type) as! Value
    }
}
