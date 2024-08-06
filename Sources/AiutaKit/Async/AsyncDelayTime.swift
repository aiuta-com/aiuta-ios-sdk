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

@_spi(Aiuta) public enum AsyncDelayTime {
    case instant
    case moment
    case sixthOfSecond
    case quarterOfSecond
    case thirdOfSecond
    case halfOfSecond
    case oneSecond
    case twoSeconds
    case severalSeconds
    case fiveSeconds
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
            case .fiveSeconds: return 5
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
        .sixthOfSecond, .quarterOfSecond, .thirdOfSecond, .halfOfSecond, .oneSecond, .twoSeconds, .severalSeconds, .fiveSeconds,
        .halfOfMinute, .oneMinute, .twoMinutes, .severalMinutes,
        .halfOfHour,
        .inoperable,
    ]
}
