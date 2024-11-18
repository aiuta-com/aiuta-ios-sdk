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
import Resolver

@_spi(Aiuta) public enum AiutaKit {
    private static let dsScope = ResolverScopeCache()
    private static let heroScope = ResolverScopeCache()

    public static func register(ds: @escaping () -> DesignSystem,
                                heroic: (() -> Heroic)? = nil,
                                imageTraits: (() -> ImageTraits)? = nil) {
        dsScope.reset()

        Resolver.register(factory: ds).scope(dsScope)

        if let heroic {
            heroScope.reset()
            Resolver.register(factory: heroic).scope(heroScope)
        } else if Resolver.optional(Heroic.self).isNil {
            Resolver.register { NoHeroes() }.implements(Heroic.self).scope(heroScope)
        }

        if let imageTraits { Resolver.register(factory: imageTraits).scope(dsScope) }
    }
}
