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

@_spi(Aiuta) open class PartialDataProvider<DataType>: DataProvider<DataType> {
    private let constantItems: [DataType]
    private var currentPrefix: Int = 0
    
    public var chunkSize: Int = 10
    
    open override var canUpdate: Bool {
        currentPrefix < constantItems.count
    }
    
    override public init(_ items: [DataType]) {
        constantItems = items
        super.init([])
    }

    override public init() {
        constantItems = []
        super.init()
    }
    
    open override func implementUpdate() {
        currentPrefix = min(currentPrefix + chunkSize, constantItems.count)
        items = Array(constantItems.prefix(currentPrefix))
    }
}
