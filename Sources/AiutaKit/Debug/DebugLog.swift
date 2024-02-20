//
// Created by nGrey on 12.11.2022.
//

import Foundation

public func trace(_ anything: Any?...,
                  file: String = #file, line: Int = #line, function: String = #function) {
    trace(statusSymbol: " ", anything: anything, file: file, line: line, function: function)
}

public func trace(i: String, _ anything: Any?...,
                  file: String = #file, line: Int = #line, function: String = #function) {
    trace(statusSymbol: i, anything: anything, file: file, line: line, function: function)
}

private func trace(statusSymbol: String, anything: [Any?], file: String, line: Int, function: String) {
    let fileName = (file as NSString).lastPathComponent
    let funcName = String(function.split(separator: "(").first ?? "func")
    let logLine = "\(fileName):\(line) .\(funcName)".padding(toLength: 50, withPad: " ", startingAt: 0) +
        "  | \(" \(statusSymbol)  |") " + anything.map { any in String(describing: any ?? "<nil>") }.joined(separator: " ")

    print(Date().timeIntervalSince1970.format("HH:mm:ss.SSS"), " | ", logLine)
    trace_interceptor?(logLine)
}

public func trace_call(_ fromFile: String, _ fromLine: Int, _ fromFunction: String,
                       file: String = #file, line: Int = #line, function: String = #function) {
    let fromFileName = (fromFile as NSString).lastPathComponent
    let fileName = (file as NSString).lastPathComponent
    let fromFuncName = String(fromFunction.split(separator: "(").first ?? "fromFunc")
    let funcName = String(function.split(separator: "(").first ?? "func")
    print(
        Date().timeIntervalSince1970.format("HH:mm:ss.SSS"),
        " | ", "\(fromFileName):\(fromLine) .\(fromFuncName)".padding(toLength: 49, withPad: " ", startingAt: 0),
        " -> ", "\(fileName):\(line) .\(funcName)"
    )
}

public var trace_interceptor: ((String) -> Void)?

public var event_interceptor: ((String, [String: Any]?, Bool) -> Void)?

public func log_event(_ name: String, _ params: [String: Any]? = nil, logAF: Bool = false) {
    event_interceptor?(name, params, logAF)
}
