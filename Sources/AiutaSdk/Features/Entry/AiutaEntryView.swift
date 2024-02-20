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
import UIKit

final class AiutaEntryView: Plane {
    let navBar = AiutaNavBar { it, ds in
        it.header.logo.view.isVisible = false
        it.header.logo.transitions.isReferenceActive = false
    }
    
    let logo = Image { it, ds in
        it.image = ds.image.sdk(.aiutaLogoEntry)
        it.transitions.reference = ds.transition.sdk(.aiutaLogo)
    }
    
    override func updateLayout() {
        logo.layout.make { make in
            make.center = .zero
        }
    }
}
