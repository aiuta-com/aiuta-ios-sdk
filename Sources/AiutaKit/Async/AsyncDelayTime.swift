//
// Created by nGrey on 17.11.2022.
//

import Foundation

public enum AsyncDelayTime {
    case instant
    case moment
    case sixthOfSecond
    case quarterOfSecond
    case thirdOfSecond
    case halfOfSecond
    case oneSecond
    case twoSeconds
    case severalSeconds
    case halfOfMinute
    case oneMinute
    case twoMinutes
    case severalMinutes
    case halfOfHour
    case custom(TimeInterval)
    case random(ClosedRange<TimeInterval>)
    case inoperable
}

public extension AsyncDelayTime {
    var seconds: TimeInterval {
        switch self {
            case .instant: return 0
            case .moment: return 0.01
            case .sixthOfSecond: return 0.16
            case .quarterOfSecond: return 0.25
            case .thirdOfSecond: return 0.35
            case .halfOfSecond: return 0.5
            case .oneSecond: return 1
            case .twoSeconds: return 2
            case .severalSeconds: return 3
            case .halfOfMinute: return 30
            case .oneMinute: return 1.minutes
            case .twoMinutes: return 2.minutes
            case .severalMinutes: return 3.minutes
            case .halfOfHour: return 30.minutes
            case let .custom(time): return time
            case let .random(range): return TimeInterval.random(in: range)
            case .inoperable: return 1000.years
        }
    }
}

public extension AsyncDelayTime {
    init(_ time: TimeInterval) {
        var candidate: AsyncDelayTime = .custom(time)
        AsyncDelayTime.allCases.forEach { item in
            if item.seconds == time { candidate = item }
        }
        self = candidate
    }

    var dispatchTime: DispatchTime {
        .now() + seconds
    }
}

extension AsyncDelayTime: Hashable, Comparable {
    public func hash(into hasher: inout Hasher) {
        seconds.hash(into: &hasher)
    }

    public static func == (lhs: AsyncDelayTime, rhs: AsyncDelayTime) -> Bool {
        lhs.seconds == rhs.seconds
    }

    public static func < (lhs: AsyncDelayTime, rhs: AsyncDelayTime) -> Bool {
        lhs.seconds < rhs.seconds
    }
}

private extension AsyncDelayTime {
    static var allCases: [AsyncDelayTime] = [
        .instant,
        .moment,
        .sixthOfSecond, .quarterOfSecond, .thirdOfSecond, .halfOfSecond, .oneSecond, .twoSeconds, .severalSeconds,
        .halfOfMinute, .oneMinute, .twoMinutes, .severalMinutes,
        .halfOfHour,
        .inoperable,
    ]
}
