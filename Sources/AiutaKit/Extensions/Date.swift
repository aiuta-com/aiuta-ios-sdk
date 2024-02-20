//
// Created by nGrey on 02.02.2023.
//

import Foundation

public extension DateFormatter {
    func string(from timestamp: TimeInterval) -> String {
        string(from: Date(timeIntervalSince1970: timestamp))
    }
}

public extension TimeInterval {
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

public extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        let years = years(from: date)
        if years > 0 { return "\(years) \("year".pluralize(count: years))" }
        let months = months(from: date)
        if months > 0 { return "\(months) \("month".pluralize(count: months))" }
        let weeks = weeks(from: date)
        if weeks > 0 { return "\(weeks) \("week".pluralize(count: weeks))" }
        let days = days(from: date)
        if days > 0 { return "\(days) \("day".pluralize(count: days))" }
        let hours = hours(from: date)
        if hours > 0 { return "\(hours) \("hour".pluralize(count: hours))" }
        let minutes = minutes(from: date)
        if minutes > 0 { return "\(minutes) min" }
        return "moment"
    }
    
    func shortOffset(from date: Date) -> String {
        let years = years(from: date)
        if years > 0 { return "\(years)Y" }
        let months = months(from: date)
        if months > 0 { return "\(months)M" }
        let weeks = weeks(from: date)
        if weeks > 0 { return "\(weeks)w" }
        let days = days(from: date)
        if days > 0 { return "\(days)d" }
        let hours = hours(from: date)
        if hours > 0 { return "\(hours)h" }
        let minutes = minutes(from: date)
        if minutes > 0 { return "\(minutes)m" }
        return "moment"
    }
}
