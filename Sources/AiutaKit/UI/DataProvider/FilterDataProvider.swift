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

@_spi(Aiuta) open class FilterDataProvider<DataType>: DataProvider<DataType> {
    private let underliyngDataProvider: DataProvider<DataType>
    public var filter: (DataType) -> Bool {
        didSet { updateItemsFromUnderliyng() }
    }

    override open var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    public init(input underliyngDataProvider: DataProvider<DataType>, filter: @escaping (DataType) -> Bool) {
        self.filter = filter
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.filter(filter))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }
    
    public func updateFilter() {
        updateItemsFromUnderliyng()
    }

    override open func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.filter(filter)
    }
}
