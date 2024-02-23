//
// Created by nGrey on 12.11.2022.
//

import Foundation

func trace(isEnabled: Bool) {
    isTraceEnabled = isEnabled
}

func trace(_ anything: Any?...,
           file: String = #file, line: Int = #line, function: String = #function) {
    trace(statusSymbol: " ", anything: anything, file: file, line: line, function: function)
}

func trace(i: String, _ anything: Any?...,
           file: String = #file, line: Int = #line, function: String = #function) {
    trace(statusSymbol: i, anything: anything, file: file, line: line, function: function)
}

private func trace(statusSymbol: String, anything: [Any?], file: String, line: Int, function: String) {
    guard isTraceEnabled else { return }
    let fileName = (file as NSString).lastPathComponent
    let funcName = String(function.split(separator: "(").first ?? "func")
    let logLine = "\(fileName):\(line) .\(funcName)".padding(toLength: 50, withPad: " ", startingAt: 0) +
        "  | \(" \(statusSymbol)  |") " + anything.map { any in String(describing: any ?? "<nil>") }.joined(separator: " ")

    print(Date().timeIntervalSince1970.format("HH:mm:ss.SSS"), " | ", logLine)
}

func trace_call(_ fromFile: String, _ fromLine: Int, _ fromFunction: String,
                file: String = #file, line: Int = #line, function: String = #function) {
    guard isTraceEnabled else { return }
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

private var isTraceEnabled = true
