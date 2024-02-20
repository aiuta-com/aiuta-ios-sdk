//
//  Created by nGrey on 02.07.2023.
//

import Foundation
import UIKit

@propertyWrapper
public struct notification<S> {
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

public final class NotificationObserver: NSObject {
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
