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
        let bundleName = "AiutaSdk_AiutaSdk"
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: SdkRegister.self).resourceURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent("\(bundleName).bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) { return bundle }
        }

        return Bundle(for: SdkRegister.self)
    }()
}

extension DesignSystemImages {
    func navigation(_ ref: SdkTheme.Navigation24) -> UIImage? { ref.custom(config) ?? bundleImage(ref.group, ref.rawValue) }
    func icon16(_ ref: SdkTheme.Icon16) -> UIImage? { ref.custom(config) ?? bundleImage(ref.group, ref.rawValue) }
    func icon24(_ ref: SdkTheme.Icon24) -> UIImage? { ref.custom(config) ?? bundleImage(ref.group, ref.rawValue) }
    func icon36(_ ref: SdkTheme.Icon36) -> UIImage? { ref.custom(config) ?? bundleImage(ref.group, ref.rawValue) }
    func splash(_ ref: SdkTheme.Splash) -> UIImage? { ref.custom(config) ?? bundleImage(ref.group, ref.rawValue) }
    func onboarding(_ ref: SdkTheme.OnBoarding) -> UIImage? { bundleImage(ref.group, ref.rawValue) }
    func tryOn(_ ref: SdkTheme.TryOn) -> UIImage? { bundleImage("", ref.rawValue) }
}

private extension DesignSystemImages {
    func bundleImage(_ group: String, _ name: String) -> UIImage? {
        UIImage(named: "aiuta\(group)\(name.firstCapitalized)", in: SdkThemeImages.resourceBundle, compatibleWith: nil)
    }
}

extension SdkTheme {
    enum Icon16: String {
        var group: String { "Icon16" }

        case arrow
        case lock
        case magic
        case spin
        case info

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .arrow: return config.icons16.arrow
                case .lock: return config.icons16.lock
                case .magic: return config.icons16.magic
                case .spin: return config.icons16.spin
                case .info: return config.icons20.info
            }
        }
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

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .camera: return config.icons24.camera
                case .cameraSwap: return config.icons24.takePhoto
                case .photoLibrary: return config.icons24.photoLibrary
                case .share: return config.icons24.share
                case .trash: return config.icons24.trash
                case .wishlist: return config.icons24.wishlist
                case .wishlistFill: return config.icons24.wishlistFill
                case .checkRounded: return config.icons24.checkCorrect
                case .checkSmall: return config.icons24.checkCorrect
                case .cross: return config.icons24.checkNotCorrect
            }
        }
    }

    enum Icon36: String {
        var group: String { "Icon36" }

        case error
        case like
        case dislike

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .error: return config.icons36.error
                case .like: return config.icons36.like
                case .dislike: return config.icons36.dislike
            }
        }
    }

    enum Navigation24: String {
        var group: String { "Nav24" }

        case back
        case close
        case history

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .back: return config.icons24.back
                case .close: return config.icons24.close
                case .history: return config.icons24.history
            }
        }
    }

    enum Splash: String {
        var group: String { "Splash" }

        case icon
        case background

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .icon: return config.icons82.splash
                case .background: return config.screens.splash
            }
        }
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
