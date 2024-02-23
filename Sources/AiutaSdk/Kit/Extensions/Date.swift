//
// Created by nGrey on 02.02.2023.
//

import Foundation

extension DateFormatter {
    func string(from timestamp: TimeInterval) -> String {
        string(from: Date(timeIntervalSince1970: timestamp))
    }
}

extension TimeInterval {
    static var now: TimeInterval { Date().timeIntervalSince1970 }

    @inlinable var seconds: TimeInterval { self }
    @inlinable var minutes: TimeInterval { self * 60 }
    @inlinable var hours: TimeInterval { minutes * 60 }
    @inlinable var days: TimeInterval { hours * 24 }
    @inlinable var years: TimeInterval { days * 365 }

    func format(_ dateFormat: String) -> String {
        sharedFormatDateFormatter.dateFormat = dateFormat
        return sharedFormatDateFormatter.string(from: self).firstCapitalized
    }

    func format(date: DateFormatter.Style = .none, time: DateFormatter.Style = .none) -> String {
        sharedStyleDateFormatter.dateStyle = date
        sharedStyleDateFormatter.timeStyle = time
        return sharedStyleDateFormatter.string(from: self)
    }
}

private var sharedStyleDateFormatter = DateFormatter()
private var sharedFormatDateFormatter = DateFormatter()
