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

@_spi(Aiuta) import AiutaKit
import UIKit

extension DesignSystemImages {
    func sdk(_ ref: AiutaSdkDesignSystemImages) -> UIImage? {
        UIImage(named: ref.rawValue, in: .module, compatibleWith: nil)
    }
}

enum AiutaSdkDesignSystemImages: String {
    case aiutaBack
    case aiutaNext
    case aiutaEmptyHistory
    case aiutaPlaceholder
    case aiutaIconCamera
    case aiutaIconGallery
    case aiutaLoader
    case aiutaMagic
    case aiutaDown
    case aiutaUp
    case aiutaOnBoard1l1
    case aiutaOnBoard1l2
    case aiutaOnBoard1l3
    case aiutaOnBoard1s1
    case aiutaOnBoard1s2
    case aiutaOnBoard1s3
    case aiutaOnBoard2
    case aiutaSelection
    case aiutaSelected
    case aiutaShare
    case aiutaTrash
    case aiutaClose
    case aiutaCross
    case aiutaError
    case aiutaLike
    case aiutaDislike
}
