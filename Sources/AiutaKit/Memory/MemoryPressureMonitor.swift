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

@_spi(Aiuta) public final class MemoryPressureMonitor {
    public static let shared = MemoryPressureMonitor()

    public let onAnyMemoryWarning = Signal<Void>()
    public let onLowMemoryWarning = Signal<Void>()
    public let onCriticalMemoryWarning = Signal<Void>()

    private let dispatchSource: DispatchSourceMemoryPressure

    private init() {
        dispatchSource = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical], queue: .main)

        dispatchSource.setEventHandler { [weak self] in
            guard let self, !self.dispatchSource.isCancelled else { return }
            switch self.dispatchSource.data {
                case .warning:
                    trace(i: "!", "Low memory warning")
                    self.onLowMemoryWarning.fire()
                    self.onAnyMemoryWarning.fire()
                case .critical:
                    trace(i: "‼", "Critical memory warning")
                    self.onCriticalMemoryWarning.fire()
                    self.onAnyMemoryWarning.fire()
                default: break
            }
        }

        dispatchSource.activate()
    }

    deinit {
        dispatchSource.cancel()
    }
}
