//
// Created by nGrey on 02.02.2023.
//

import Foundation

public func dog(_ name: String, priority: Int = 0) -> WatchItemBuilder {
    if kennel[name] == nil { kennel[name] = [String: () -> Any?]() }
    kennelPriority[name] = priority
    return WatchItemBuilder(name)
}

public class WatchItemBuilder {
    private let group: String

    init(_ group: String) {
        self.group = group
    }

    @discardableResult
    public func watch(_ key: String, _ value: @escaping () -> Any?) -> WatchItemBuilder {
        kennel[group]?[key] = value
        return self
    }

    @discardableResult
    public func log(_ key: String, _ value: Any?) -> WatchItemBuilder {
        watch(key) { value }
    }

    @discardableResult
    public func br(_ key: String) -> WatchItemBuilder {
        log(key + breakSuffix, nil)
    }
}

public func dog(_ length: Int) -> String {
    var lines = [String]()
    for (topic, items) in kennel.sorted() {
        lines.append("\(topic.uppercased())\n")
        for (k, v) in items.sorted() {
            if k.hasSuffix(breakSuffix) {
                lines.append("")
                continue
            }
            lines.append(" • \(k) ".padding(toLength: length, withPad: "·", startingAt: 0) + "· \(v().logUnwrap)")
        }
        lines.append("\n")
    }
    return lines.joined(separator: "\n")
}

private var kennel = [String: [String: () -> Any?]]()
private var kennelPriority = [String: Int]()
private let breakSuffix = "zzz:::"
private let numberFormat = "%.3f"

private extension Dictionary where Key == String {
    func sorted() -> [Self.Element] {
        sorted(by: {
            let p0 = kennelPriority[$0.0] ?? 0
            let p1 = kennelPriority[$1.0] ?? 0
            return p0 == p1 ? $0.0 < $1.0 : p0 > p1
        })
    }
}

private extension Optional {
    var logUnwrap: Any {
        switch self {
            case .none:
                return ".none"
            case let .some(value):
                return describe(value)
        }
    }

    private func describe(_ value: Any) -> String {
        if value is Double {
            return String(format: numberFormat, value as! Double)
        }
        if value is Float {
            return String(format: numberFormat, value as! Float)
        }
        if value is CGFloat {
            return String(format: numberFormat, value as! CGFloat)
        }
        return String(describing: value)
    }
}
