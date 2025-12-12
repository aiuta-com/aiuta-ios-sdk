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
import UIKit

extension Sdk {
    struct Configuration {
        var auth = Auth()
        var styles = Styles()
        var colors = Colors()
        var fonts = Fonts()
        var shapes = Shapes()
        var icons = Icons()
        var images = Images()
        var strings = Strings()
        var features = Features()
        var settings = DebugSettings()

        init() {}

        init(_ preset: Aiuta.Configuration) {
            apply(preset, to: &self)
            validate(self)
        }
    }
}
