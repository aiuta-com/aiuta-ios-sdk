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

@_spi(Aiuta) public final class Breadcrumbs {
    public static func enable(with observer: AnyObject, onFire: @escaping (Breadcrumbs) -> Void, onLeft: @escaping (Breadcrumb) -> Void) {
        guard !isEnabled else { fatalError("Breadcrumbs can be enabled only once") }
        onBreadcrumbsFired.subscribe(with: observer, callback: onFire)
        onBreadcrumbsLeave.subscribe(with: observer, callback: onLeft)
        isEnabled = true
    }

    private static let onBreadcrumbsFired = Signal<Breadcrumbs>()
    private static let onBreadcrumbsLeave = Signal<Breadcrumb>(retainLastData: true)
    private static var isEnabled = false

    public struct Breadcrumb {
        public let signal: String?
        public let sender: String?
        public let function: String
        public let file: String
        public let line: Int
    }

    public enum StackFrame: Equatable {
        case symbolic(name: String, file: String, line: Int)
        case address(UInt)
    }

    public private(set) var stackTrace = [StackFrame]()
    public private(set) var name: String!
    public private(set) var error: String!

    private let lock = UnfairLock()

    public init(on signal: String? = nil, of sender: String? = nil,
                in function: String = #function, file: String = #file, line: Int = #line) {
        guard Breadcrumbs.isEnabled else { return }

        let callstack = Thread.callStackSymbols.compactMap { getCallStackAddress($0) }
        stackTrace = callstack.map { StackFrame.address($0) }
    }

    @discardableResult
    public func add(on signal: String? = nil, of sender: String? = nil,
                    in function: String = #function, file: String = #file, line: Int = #line) -> Breadcrumbs {
        guard Breadcrumbs.isEnabled else { return self }

        let file = (file as NSString).lastPathComponent
        let object = (file as NSString).deletingPathExtension
        var symbol = ""
        if let signal { symbol += "\(signal) " }
        if let sender { symbol += "of \(sender) " }
        if !symbol.isEmpty { symbol += "in " }
        symbol += function
        if symbol == object { symbol = "Breadcrumbs()" }
        let frame = StackFrame.symbolic(name: symbol, file: file, line: line)

        var didUpdate = false
        lock.synchronize {
            if stackTrace.first != frame {
                stackTrace.insert(frame, at: 0)
                didUpdate = true
            }
        }
        guard didUpdate else { return self }

        dispatch(.main) {
            let breadcrumb = Breadcrumb(signal: signal, sender: sender,
                                        function: function, file: file, line: line)
            if Breadcrumbs.onBreadcrumbsLeave.lastDataFired != breadcrumb {
                Breadcrumbs.onBreadcrumbsLeave.fire(breadcrumb)
            }
        }
        return self
    }

    public func fork(on signal: String? = nil, of sender: String? = nil,
                     in function: String = #function, file: String = #file, line: Int = #line) -> Breadcrumbs {
        guard Breadcrumbs.isEnabled else { return self }

        let breadcrumbsCopy = Breadcrumbs(stackTrace)
        breadcrumbsCopy.add(on: signal, of: sender, in: function, file: file, line: line)
        return breadcrumbsCopy
    }

    public func fire(_ error: Error?, label name: String, on signal: String? = nil, of sender: String? = nil,
                     in function: String = #function, file: String = #file, line: Int = #line) {
        if let error { fire(String(reflecting: error), label: name, on: signal, of: sender, in: function, file: file, line: line) }
        else { fire("<no handled error>", label: name, on: signal, of: sender, in: function, file: file, line: line) }
    }

    public func fire(_ error: String, label name: String, on signal: String? = nil, of sender: String? = nil,
                     in function: String = #function, file: String = #file, line: Int = #line) {
        guard Breadcrumbs.isEnabled else { return }

        add(on: signal, of: sender, in: function, file: file, line: line)
        trace(i: "x", name, signal, sender, "\n\n\(error)\n")

        lock.synchronize {
            self.name = name
            self.error = error
            Breadcrumbs.onBreadcrumbsFired.fire(self)
        }
    }

    private init(_ stackTrace: [StackFrame]) {
        self.stackTrace = stackTrace
    }

    private func getCallStackAddress(_ line: String) -> UInt? {
        let parts = line.split(separator: " ")
        for part in parts {
            if part.hasPrefix("0x") {
                return UInt(part.dropFirst(2), radix: 16)
            }
        }
        return nil
    }
}

@_spi(Aiuta) extension Breadcrumbs.Breadcrumb: Equatable {
    public static func == (lhs: Breadcrumbs.Breadcrumb, rhs: Breadcrumbs.Breadcrumb) -> Bool {
        lhs.file == rhs.file && lhs.function == rhs.function && lhs.signal == rhs.signal && lhs.sender == rhs.sender
    }
}

@_spi(Aiuta) public extension Breadcrumbs.Breadcrumb {
    var asDictionary: [String: Any] {
        var result: [String: Any] = [
            "function": function,
            "file": file,
            "line": line,
        ]
        if let signal { result["signal"] = signal }
        if let sender { result["sender"] = sender }
        return result
    }
}
