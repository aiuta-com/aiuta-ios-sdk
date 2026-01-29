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
    final class Shape: Scroll {
        let didChange = Signal<Void>()
        
        var bellyShape: Aiuta.FitSurvey.BellyShape? {
            didSet {
                guard oldValue != bellyShape else { return }
                bellyCells.updateItems()
            }
        }

        var hipShape: Aiuta.FitSurvey.HipShape? {
            didSet {
                guard oldValue != hipShape else { return }
                hipCells.updateItems()
            }
        }

        @scrollable
        var bellyHeader = Header { it, _ in
            it.text = "Belly shape"
        }

        @scrollable
        var bellyCells = BellyCell.ScrollRecycler()

        @scrollable
        var hipHeader = Header { it, _ in
            it.text = "Hip shape"
        }

        @scrollable
        var hipCells = HipCell.ScrollRecycler()

        var insets: UIEdgeInsets = .zero

        override func setup() {
            scrollView.itemSpace = 12
            scrollView.flexibleWidth = false

            bellyCells.onUpdateItem.subscribe(with: self) { [unowned self] cell in
                cell.isSelected = cell.data == bellyShape
            }

            hipCells.onUpdateItem.subscribe(with: self) { [unowned self] cell in
                cell.isSelected = cell.data == hipShape
            }

            bellyCells.onTapItem.subscribe(with: self) { [unowned self] cell in
                bellyShape = cell.data
                didChange.fire()
            }

            hipCells.onTapItem.subscribe(with: self) { [unowned self] cell in
                hipShape = cell.data
                didChange.fire()
            }

            bellyCells.data = DataProvider(Aiuta.FitSurvey.BellyShape.allCases)
            hipCells.data = DataProvider(Aiuta.FitSurvey.HipShape.allCases)
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

    class ShapeCell<T>: Recycle<T> {
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

    class ShapeRecycler<RecycleViewType, RecycleDataType>: VRecycler<RecycleViewType, RecycleDataType> where RecycleViewType: Recycle<RecycleDataType>, RecycleDataType: Equatable {
        override func setup() {
            renderAlways = true
            contentInsets = .init(top: 16, left: 12, bottom: 0, right: 12)
            contentSpace = .init(square: 8)
            contentFraction = .init(width: .fraction(1 / 3), height: .widthMultiplyer(140 / 115))
        }
    }

    final class BellyCell: ShapeCell<Aiuta.FitSurvey.BellyShape> {
        final class ScrollRecycler: ShapeRecycler<BellyCell, Aiuta.FitSurvey.BellyShape> { }

        override func update(_ data: Aiuta.FitSurvey.BellyShape?, at index: ItemIndex) {
            switch data {
                case .Flat:
                    title.text = "Flatter"
                case .Normal:
                    title.text = "Average"
                case .Curvy:
                    title.text = "Full"
                case nil:
                    title.text = nil
            }
        }
    }

    final class HipCell: ShapeCell<Aiuta.FitSurvey.HipShape> {
        final class ScrollRecycler: ShapeRecycler<HipCell, Aiuta.FitSurvey.HipShape> { }

        override func update(_ data: Aiuta.FitSurvey.HipShape?, at index: ItemIndex) {
            switch data {
                case .Slim:
                    title.text = "Straight"
                case .Normal:
                    title.text = "Average"
                case .Curvy:
                    title.text = "Wide"
                case nil:
                    title.text = nil
            }
        }
    }
}
