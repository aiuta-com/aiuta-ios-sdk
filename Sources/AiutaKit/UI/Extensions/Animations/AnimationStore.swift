//
// Created by nGrey on 03.02.2023.
//

import UIKit

extension CALayer {
    private struct AssociatedKeys {
        static var storedAnimations: UInt8 = 0
    }

    public func storeAnimations() {
        pauseAnimations()
        saveAnimations()
    }

    public func restoreAnimations() {
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

    public func pauseAnimations() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0
        timeOffset = pausedTime
    }

    public func resumeAnimations() {
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
