//
// Created by nGrey on 03.02.2023.
//

import Foundation

public extension Array {
    /// let array = [1, 2, 3, 4]
    /// let newArray = array >> 1
    /// // newArray: [4, 1, 2, 3]
    /// Complexity `O(n)`
    static func >> (left: Self, right: UInt) -> Self {
        guard !left.isEmpty else {
            return left
        }
        guard right != 0, Int(right) % left.count != 0 else {
            return left
        }
        var result = left
        left.indices.forEach {
            result[($0 + Int(right)) % left.count] = left[$0]
        }
        return result
    }

    /// let array = [1, 2, 3, 4]
    /// let newArray = array << 1
    /// // newArray: [2, 3, 4, 1]
    /// Complexity `O(n)`
    static func << (left: Self, right: UInt) -> Self {
        guard !left.isEmpty else {
            return left
        }
        guard right != 0, Int(right) % left.count != 0 else {
            return left
        }
        var result = left
        let shiftBy = Int(right) % left.count
        left.indices.forEach {
            let newIndex = (left.count + $0 - shiftBy) % left.count
            result[newIndex] = left[$0]
        }
        return result
    }

    mutating func safeRemoveFirst() -> Element? {
        guard count > 0 else { return nil }
        return removeFirst()
    }

    func chunked(by chunkSize: Int) -> [ArraySlice<Element>] {
        guard chunkSize > 0 else { return [] }
        return stride(from: 0, to: count, by: chunkSize).map {
            ArraySlice(self[$0 ..< Swift.min($0 + chunkSize, count)])
        }
    }
}

public extension Array where Element == Int {
    func greatestCommonDivisor() -> Int? {
        guard !isEmpty else { return nil }
        return reduce(0, gcdIterativeEuklid)
    }

    private func gcdIterativeEuklid(_ m: Int, _ n: Int) -> Int {
        var a: Int = 0
        var b: Int = Swift.max(m, n)
        var r: Int = Swift.min(m, n)

        while r != 0 {
            a = b
            b = r
            r = a % b
        }
        return b
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
