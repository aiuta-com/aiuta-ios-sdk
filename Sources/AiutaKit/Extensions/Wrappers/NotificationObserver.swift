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
import UIKit

@propertyWrapper
@_spi(Aiuta) public struct notification<S> {
    private let observer: NotificationObserver

    public init(_ name: NSNotification.Name) {
        observer = NotificationObserver(name)
    }

    public var wrappedValue: S {
        if observer.onSimpleNotification is S { return observer.onSimpleNotification as! S }
        if observer.onWerboseNotification is S { return observer.onWerboseNotification as! S }
        fatalError("Notification wrapped value should be Signal<Void> or Signal<Notification>")
    }
}

@_spi(Aiuta) public final class NotificationObserver: NSObject {
    public let onSimpleNotification = Signal<Void>()
    public let onWerboseNotification = Signal<Notification>()

    private let notificationName: NSNotification.Name
    private let notificationCenter: NotificationCenter

    init(_ notificationName: NSNotification.Name, notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        self.notificationName = notificationName
        super.init()
        notificationCenter.addObserver(self, selector: #selector(notify),
                                       name: notificationName, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self, name: notificationName, object: nil)
    }

    @objc private func notify(_ notification: Notification) {
        onWerboseNotification.fire(notification)
        onSimpleNotification.fire()
    }
}
