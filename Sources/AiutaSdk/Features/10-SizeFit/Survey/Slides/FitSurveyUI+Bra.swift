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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

extension FitSurveyUI {
    final class Bra: Scroll {
        let didChange = Signal<Void>()
        
        var braSize: Int? {
            didSet {
                guard oldValue != braSize else { return }
                chestCells.updateItems()
            }
        }

        var braCup: Aiuta.FitSurvey.BraCup? {
            didSet {
                guard oldValue != braCup else { return }
                cupCells.updateItems()
            }
        }
        
        @scrollable
        var header = Header { it, _ in
            it.text = "Bra size"
        }

        @scrollable
        var chestHeader = Header { it, _ in
            it.isSmall = true
            it.text = "Chest circumference"
        }

        @scrollable
        var chestCells = ChestCell.ScrollRecycler()

        @scrollable
        var cupHeader = Header { it, _ in
            it.isSmall = true
            it.text = "Bra cup"
        }

        @scrollable
        var cupCells = CupCell.ScrollRecycler()

        var insets: UIEdgeInsets = .zero

        override func setup() {
            scrollView.itemSpace = 12
            scrollView.flexibleWidth = false
            
            chestCells.onUpdateItem.subscribe(with: self) { [unowned self] cell in
                cell.isSelected = cell.data == braSize
            }

            cupCells.onUpdateItem.subscribe(with: self) { [unowned self] cell in
                cell.isSelected = cell.data == braCup
            }

            chestCells.onTapItem.subscribe(with: self) { [unowned self] cell in
                braSize = cell.data
                didChange.fire()
            }

            cupCells.onTapItem.subscribe(with: self) { [unowned self] cell in
                braCup = cell.data
                didChange.fire()
            }

            chestCells.data = DataProvider([60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125])
            cupCells.data = DataProvider(Aiuta.FitSurvey.BraCup.allCases)
        }

        override func updateLayout() {
            layout.make { make in
                make.size = layout.boundary.size
            }

            scrollView.keepOffset {
                scrollView.contentInset = .init(top: insets.top,
                                                bottom: insets.bottom + 16)
            }
        }
    }

    class BraCell<T>: Recycle<T> {
        var isSelected: Bool = false {
            didSet {
                guard isSelected != oldValue else { return }
                view.borderColor = isSelected ? ds.colors.primary : ds.colors.border
                view.borderWidth = isSelected ? 2 : 1
            }
        }

        override func setup() {
            view.borderWidth = 1
            view.borderColor = ds.colors.border
        }

        let title = Label { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
        }

        override func updateLayout() {
            layout.make { make in
                make.radius = 16
            }

            title.layout.make { make in
                make.center = .zero
            }
        }
    }

    class BraRecycler<RecycleViewType, RecycleDataType>: VRecycler<RecycleViewType, RecycleDataType> where RecycleViewType: Recycle<RecycleDataType>, RecycleDataType: Equatable {
        override func setup() {
            renderAlways = true
            contentInsets = .init(top: 16, left: 20, bottom: 24, right: 20)
            contentSpace = .init(square: 8)
            contentFraction = .init(width: .fraction(1 / 6), height: .widthMultiplyer(1))
        }
    }

    final class ChestCell: BraCell<Int> {
        final class ScrollRecycler: BraRecycler<ChestCell, Int> { }

        override func update(_ data: Int?, at index: ItemIndex) {
            if let data {
                title.text = "\(data)"
            } else {
                title.text = nil
            }
        }
    }

    final class CupCell: BraCell<Aiuta.FitSurvey.BraCup> {
        final class ScrollRecycler: BraRecycler<CupCell, Aiuta.FitSurvey.BraCup> { }

        override func update(_ data: Aiuta.FitSurvey.BraCup?, at index: ItemIndex) {
            title.text = data?.rawValue
        }
    }
}
