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

import UIKit

@_spi(Aiuta) public extension CALayer {
    private struct AssociatedKeys {
        static var storedAnimations: UInt8 = 0
    }

    func storeAnimations() {
        pauseAnimations()
        saveAnimations()
    }

    func restoreAnimations() {
        loadAnimations()
        resumeAnimations()
    }

    private var storedAnimations: [String: CAAnimation] {
        get { getAssociatedProperty(&AssociatedKeys.storedAnimations, ofType: [String: CAAnimation].self) ?? [:] }
        set { setAssociatedProperty(&AssociatedKeys.storedAnimations, newValue: newValue as NSDictionary) }
    }

    private var activeAnimations: [String: CAAnimation] {
        animationKeys()?.reduce(into: [:], { $0[$1] = (animation(forKey: $1)!.copy() as! CAAnimation) }) ?? [:]
    }

    func pauseAnimations() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0
        timeOffset = pausedTime
    }

    func resumeAnimations() {
        let pausedTime = timeOffset
        speed = 1
        timeOffset = 0
        beginTime = 0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }

    private func saveAnimations() {
        storedAnimations = activeAnimations
        sublayers?.forEach { $0.saveAnimations() }
    }

    private func loadAnimations() {
        sublayers?.forEach { $0.loadAnimations() }
        storedAnimations.forEach { add($0.value, forKey: $0.key) }
        storedAnimations = [:]
    }
}
