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
import StoreKit

@_spi(Aiuta) public extension DateFormatter {
    convenience init(bulder: (DateFormatter) -> Void) {
        self.init()
        bulder(self)
    }

    func string(from timestamp: TimeInterval) -> String {
        string(from: Date(timeIntervalSince1970: timestamp))
    }
}

@_spi(Aiuta) public extension NumberFormatter {
    convenience init(bulder: (NumberFormatter) -> Void) {
        self.init()
        bulder(self)
    }

    @available(iOS 15.0, *)
    func string(from value: Decimal, with style: Decimal.FormatStyle.Currency) -> String? {
        locale = style.locale
        currencyCode = style.currencyCode
        return string(from: value as NSDecimalNumber)
    }

    @available(iOS 15.0, *)
    func string(from value: Decimal, with style: Decimal.FormatStyle.Currency, per period: Product.SubscriptionPeriod? = nil) -> String? {
        guard let period else { return string(from: value, with: style) }
        return string(from: value, with: style, per: period.unit, count: period.value)
    }

    @available(iOS 15.0, *)
    func string(from value: Decimal, with style: Decimal.FormatStyle.Currency, per unit: Product.SubscriptionPeriod.Unit, count: Int = 1) -> String? {
        guard let str = string(from: value, with: style) else { return nil }
        let periodStr = "\(unit)".lowercased()
        if count > 1 { return "\(str)/\(count) \(periodStr)" }
        else { return "\(str)/\(periodStr)" }
    }
}
