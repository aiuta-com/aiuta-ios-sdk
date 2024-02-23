//
//  Created by nGrey on 02.07.2023.
//

import Foundation
import UIKit

@propertyWrapper
struct notification<S> {
    private let observer: NotificationObserver

    init(_ name: NSNotification.Name) {
        observer = NotificationObserver(name)
    }

    var wrappedValue: S {
        if observer.onSimpleNotification is S { return observer.onSimpleNotification as! S }
        if observer.onWerboseNotification is S { return observer.onWerboseNotification as! S }
        fatalError("Notification wrapped value should be Signal<Void> or Signal<Notification>")
    }
}

final class NotificationObserver: NSObject {
    let onSimpleNotification = Signal<Void>()
    let onWerboseNotification = Signal<Notification>()

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
