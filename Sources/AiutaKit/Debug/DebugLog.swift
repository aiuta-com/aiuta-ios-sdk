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

@_spi(Aiuta) public func trace(isEnabled: Bool) {
    isTraceEnabled = isEnabled
}

@_spi(Aiuta) public func trace(_ anything: Any?...,
                               file: String = #file, line: Int = #line, function: String = #function) {
    trace(statusSymbol: " ", anything: anything, file: file, line: line, function: function)
}

@_spi(Aiuta) public func trace(i: String, _ anything: Any?...,
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

@_spi(Aiuta) public func trace_call(_ fromFile: String, _ fromLine: Int, _ fromFunction: String,
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
