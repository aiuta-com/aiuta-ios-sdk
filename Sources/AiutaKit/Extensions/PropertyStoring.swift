//
// Created by nGrey on 03.11.2022.
//

import Foundation

public protocol PropertyStoring {}

public extension PropertyStoring {
    func getAssociatedProperty<Property>(_ key: UnsafeRawPointer!, ofType: Property.Type) -> Property? {
        objc_getAssociatedObject(self, key) as? Property
    }

    func getAssociatedProperty<Property>(_ key: UnsafeRawPointer!, defaultValue: Property) -> Property {
        if let value = objc_getAssociatedObject(self, key) as? Property {
            return value
        }
        return defaultValue
    }

    @discardableResult
    func setAssociatedProperty<Property>(_ key: UnsafeRawPointer!, newValue: Property) -> Property {
        setAssociatedProperty(key, newValue: newValue, policy: .OBJC_ASSOCIATION_RETAIN)
        return newValue
    }

    @discardableResult
    func setAssociatedProperty<Property>(_ key: UnsafeRawPointer!, newValue: Property, policy: objc_AssociationPolicy) -> Property {
        objc_setAssociatedObject(self, key, newValue, policy)
        return newValue
    }
}

extension NSObject: PropertyStoring {}
