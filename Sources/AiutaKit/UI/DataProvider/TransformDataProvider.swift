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

@_spi(Aiuta) open class TransformDataProvider<InDataType, OutDataType>: DataProvider<OutDataType> {
    private let underliyngDataProvider: DataProvider<InDataType>
    private let transform: (InDataType) -> OutDataType

    override open var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    public init(input underliyngDataProvider: DataProvider<InDataType>, transform: @escaping (InDataType) -> OutDataType) {
        self.transform = transform
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.map(transform))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }

    public convenience init?(input underliyngDataProvider: DataProvider<InDataType>?, transform: @escaping (InDataType) -> OutDataType) {
        guard let underliyngDataProvider else { return nil }
        self.init(input: underliyngDataProvider, transform: transform)
    }

    override open func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.map(transform)
    }
}

@_spi(Aiuta) open class FlatMapDataProvider<InDataType, OutDataType>: DataProvider<OutDataType> {
    private let underliyngDataProvider: DataProvider<InDataType>
    private let transform: (InDataType) -> [OutDataType]

    override open var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    public init(input underliyngDataProvider: DataProvider<InDataType>, transform: @escaping (InDataType) -> [OutDataType]) {
        self.transform = transform
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.flatMap(transform))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }

    public convenience init?(input underliyngDataProvider: DataProvider<InDataType>?, transform: @escaping (InDataType) -> OutDataType) {
        guard let underliyngDataProvider else { return nil }
        self.init(input: underliyngDataProvider, transform: transform)
    }

    override open func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.flatMap(transform)
    }
}
