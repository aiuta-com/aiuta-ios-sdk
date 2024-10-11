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

struct SdkThemeImages: DesignSystemImages {
    static let resourceBundle: Bundle? = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: SdkRegister.self).resourceURL,
        ]

        let bundleName = "AiutaSdk_AiutaSdk"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: SdkRegister.self)
    }()
}

extension DesignSystemImages {
    func navigation(_ ref: SdkTheme.Navigation24) -> UIImage? { getImage(ref.group, ref.rawValue) }
    func icon16(_ ref: SdkTheme.Icon16) -> UIImage? { getImage(ref.group, ref.rawValue) }
    func icon24(_ ref: SdkTheme.Icon24) -> UIImage? { getImage(ref.group, ref.rawValue) }
    func icon36(_ ref: SdkTheme.Icon36) -> UIImage? { getImage(ref.group, ref.rawValue) }
    func onboarding(_ ref: SdkTheme.OnBoarding) -> UIImage? { getImage(ref.group, ref.rawValue) }
    func tryOn(_ ref: SdkTheme.TryOn) -> UIImage? { getImage("", ref.rawValue) }
}

private extension DesignSystemImages {
    func getImage(_ group: String, _ name: String) -> UIImage? {
        UIImage(named: "aiuta\(group)\(name.firstCapitalized)", in: SdkThemeImages.resourceBundle, compatibleWith: nil)
    }
}

extension SdkTheme {
    enum Icon16: String {
        var group: String { "Icon16" }

        case arrowSmall
        case lock
        case magic
        case spin
    }

    enum Icon24: String {
        var group: String { "Icon24" }

        case camera
        case cameraSwap
        case photoLibrary
        case share
        case trash
        case wishlist
        case wishlistFill

        case checkRounded
        case checkSmall
        case cross
    }

    enum Icon36: String {
        var group: String { "Icon36" }

        case error
        case like
        case dislike
    }

    enum Navigation24: String {
        var group: String { "Nav24" }

        case back
        case close
        case history
    }

    enum OnBoarding: String {
        var group: String { "Board" }

        case how1L
        case how1S
        case how2L
        case how2S
        case how3L
        case how3S

        case best1
        case best2
        case best3
        case best4
    }

    enum TryOn: String {
        case photoPlaceholder
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
