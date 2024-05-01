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

@_spi(Aiuta) public final class AnalyticRouter: AnalyticTracker {
    public enum LeveledTarget {
        case ordinary(AnalyticTarget)
        case significant(AnalyticTarget)
    }

    private let targets: [(AnalyticTarget, AnalyticEvent.Level)]

    public init(_ targets: LeveledTarget...) {
        self.targets = targets.map {
            switch $0 {
                case let .ordinary(target): return (target, .ordinary)
                case let .significant(target): return (target, .significant)
            }
        }
    }

    public func track(_ event: AnalyticEvent) {
        targets.forEach { target, level in
            if event.level >= level {
                target.eventOccured(event)
            }
        }
    }
}
