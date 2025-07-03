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

@_spi(Aiuta) public protocol PropertyStoring {}

@_spi(Aiuta) public extension PropertyStoring {
    func getAssociatedProperty<Property>(_ key: UnsafeRawPointer, ofType: Property.Type) -> Property? {
        objc_getAssociatedObject(self, key) as? Property
    }

    func getAssociatedProperty<Property>(_ key: UnsafeRawPointer, defaultValue: @autoclosure () -> Property) -> Property {
        if let value = objc_getAssociatedObject(self, key) as? Property { return value }
        return defaultValue()
    }

    @discardableResult
    func setAssociatedProperty<Property>(_ key: UnsafeRawPointer, newValue: Property) -> Property {
        setAssociatedProperty(key, newValue: newValue, policy: .OBJC_ASSOCIATION_RETAIN)
        return newValue
    }

    @discardableResult
    func setAssociatedProperty<Property>(_ key: UnsafeRawPointer, newValue: Property, policy: objc_AssociationPolicy) -> Property {
        objc_setAssociatedObject(self, key, newValue, policy)
        return newValue
    }
}

@_spi(Aiuta) extension NSObject: PropertyStoring {}
