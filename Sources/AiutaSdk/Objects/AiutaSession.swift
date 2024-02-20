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

import AiutaKit

extension Aiuta {
    final class TryOnSession {
        let tryOnSku: SkuInfo
        let moreToTryOn: [SkuInfo]
        weak var delegate: AiutaSdkDelegate?

        init(tryOnSku: SkuInfo, moreToTryOn: [SkuInfo], delegate: AiutaSdkDelegate) {
            self.tryOnSku = tryOnSku
            self.moreToTryOn = moreToTryOn
            self.delegate = delegate
        }
    }
}

extension Aiuta.SkuInfo: Equatable {
    public static func == (lhs: Aiuta.SkuInfo, rhs: Aiuta.SkuInfo) -> Bool {
        lhs.skuId == rhs.skuId && lhs.skuCatalog == rhs.skuCatalog
    }
}
