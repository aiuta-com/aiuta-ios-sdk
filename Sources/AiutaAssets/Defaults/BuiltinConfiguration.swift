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

import AiutaConfig
import AiutaCore
import AiutaDefaults

extension Aiuta.Configuration {
    public static func `default`(
        auth: Aiuta.Auth,
        cartHandler: Aiuta.Configuration.Features.TryOn.Cart.Handler,
        analytics: Aiuta.Analytics? = nil,
        debugSettings: DebugSettings = .release,
        localization: LocalizationPack = .init(),
        colors: ColorsPack = .init(),
        typography: TypographyPack = .init(),
        shapes: ShapesPack = .init()
    ) -> Self {
        .default(
            auth: auth,
            cartHandler: cartHandler,
            analytics: analytics,
            debugSettings: debugSettings,
            localization: localization,
            colors: colors,
            icons: .builtin,
            images: .builtin,
            typography: typography,
            shapes: shapes
        )
    }
}
