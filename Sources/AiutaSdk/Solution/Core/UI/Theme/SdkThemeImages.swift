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
    func navigation(_ ref: SdkTheme.Navigation24) -> UIImage? { ref.custom(config.icons.icons24) ?? bundleImage(ref.group, ref.rawValue) }
    func icon14(_ ref: SdkTheme.Icon14) -> UIImage? { ref.custom(config.icons.icons14) ?? bundleImage(ref.group, ref.rawValue) }
    func icon16(_ ref: SdkTheme.Icon16) -> UIImage? { ref.custom(config.icons.icons16) ?? bundleImage(ref.group, ref.rawValue) }
    func icon20(_ ref: SdkTheme.Icon20) -> UIImage? { ref.custom(config.icons.icons20) ?? bundleImage(ref.group, ref.rawValue) }
    func icon24(_ ref: SdkTheme.Icon24) -> UIImage? { ref.custom(config.icons.icons24) ?? bundleImage(ref.group, ref.rawValue) }
    func icon36(_ ref: SdkTheme.Icon36) -> UIImage? { ref.custom(config.icons.icons36) ?? bundleImage(ref.group, ref.rawValue) }
    func icon82(_ ref: SdkTheme.Icon82) -> UIImage? { ref.custom(config.icons.icons82) ?? bundleImage(ref.group, ref.rawValue) }
    func images(_ ref: SdkTheme.Images) -> UIImage? { ref.custom(config.images) ?? bundleImage(ref.group, ref.rawValue) }
    func onboarding(_ ref: SdkTheme.OnBoarding) -> UIImage? { bundleImage(ref.group, ref.rawValue) }
    func tryOn(_ ref: SdkTheme.TryOn) -> UIImage? { bundleImage("", ref.rawValue) }
}

private extension DesignSystemImages {
    func bundleImage(_ group: String, _ name: String) -> UIImage? {
        UIImage(named: "aiuta\(group)\(name.firstCapitalized)", in: SdkThemeImages.resourceBundle, compatibleWith: nil)
    }
}

extension SdkTheme {
    enum Icon14: String {
        var group: String { "Icon14" }

        case spin

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons14) -> UIImage? {
            switch self {
                case .spin: return config.spin
            }
        }
    }

    enum Icon16: String {
        var group: String { "Icon16" }

        case arrow
        case lock
        case magic

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons16) -> UIImage? {
            switch self {
                case .arrow: return config.arrow
                case .lock: return config.lock
                case .magic: return config.magic
            }
        }
    }

    enum Icon20: String {
        var group: String { "Icon20" }

        case check
        case info

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons20) -> UIImage? {
            switch self {
                case .check: return config.check
                case .info: return config.info
            }
        }
    }

    enum Icon24: String {
        var group: String { "Icon24" }

        case camera
        case cameraSwap
        case checkCorrect
        case checkNotCorrect
        case photoLibrary
        case share
        case trash
        case wishlist
        case wishlistFill

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons24) -> UIImage? {
            switch self {
                case .camera: return config.camera
                case .cameraSwap: return config.cameraSwap
                case .checkCorrect: return config.checkCorrect
                case .checkNotCorrect: return config.checkNotCorrect
                case .photoLibrary: return config.photoLibrary
                case .share: return config.share
                case .trash: return config.trash
                case .wishlist: return config.wishlist
                case .wishlistFill: return config.wishlistFill
            }
        }
    }

    enum Navigation24: String {
        var group: String { "Nav24" }

        case back
        case close
        case history

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons24) -> UIImage? {
            switch self {
                case .back: return config.back
                case .close: return config.close
                case .history: return config.history
            }
        }
    }

    enum Icon36: String {
        var group: String { "Icon36" }

        case error
        case like
        case dislike

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons36) -> UIImage? {
            switch self {
                case .error: return config.error
                case .like: return config.like
                case .dislike: return config.dislike
            }
        }
    }

    enum Icon82: String {
        var group: String { "Icon82" }

        case splash

        func custom(_ config: Aiuta.Configuration.Appearance.Icons.Icons82) -> UIImage? {
            switch self {
                case .splash: return config.splash
            }
        }
    }

    enum Images: String {
        var group: String { "Image" }

        case splashScreen

        func custom(_ config: Aiuta.Configuration.Appearance.Images) -> UIImage? {
            switch self {
                case .splashScreen: return config.splashScreen
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
