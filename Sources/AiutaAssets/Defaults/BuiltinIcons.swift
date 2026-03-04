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

import AiutaDefaults
import UIKit

extension IconsPack {
    public static var builtin: Self {
        .init(
            back24: AiutaAssets.bundleImage("aiutaIcon24Back")!,
            close24: AiutaAssets.bundleImage("aiutaIcon24Close")!,
            trash24: AiutaAssets.bundleImage("aiutaIcon24Trash")!,
            check20: AiutaAssets.bundleImage("aiutaIcon20Check")!,
            error36: AiutaAssets.bundleImage("aiutaIcon36Error")!,
            imageError36: AiutaAssets.bundleImage("aiutaIcon36ImageError")!,
            arrow16: AiutaAssets.bundleImage("aiutaIcon16Arrow")!,
            loading14: nil,
            camera24: AiutaAssets.bundleImage("aiutaIcon24Camera")!,
            gallery24: AiutaAssets.bundleImage("aiutaIcon24Gallery")!,
            selectModels24: AiutaAssets.bundleImage("aiutaIcon24Model")!,
            magic20: AiutaAssets.bundleImage("aiutaIcon20Magic")!,
            changePhoto24: AiutaAssets.bundleImage("aiutaIcon24CameraSwap")!,
            history24: AiutaAssets.bundleImage("aiutaIcon24History")!,
            like36: AiutaAssets.bundleImage("aiutaIcon36Like")!,
            dislike36: AiutaAssets.bundleImage("aiutaIcon36Dislike")!,
            share24: AiutaAssets.bundleImage("aiutaIcon24Share")!
        )
    }
}
