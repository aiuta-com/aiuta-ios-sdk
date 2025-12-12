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
@_spi(Aiuta) import AiutaKit
import Resolver
import UIKit

extension Sdk.Configuration {
    struct Styles {
        var presentationStyle: Aiuta.Configuration.UserInterface.PresentationStyle = .pageSheet
        var swipeToDismissPolicy: Aiuta.Configuration.UserInterface.SwipeToDismissPolicy = .protectTheNecessaryPages
        var preferCloseButtonOnTheRight: Bool = false
        var extendDelimitersToTheRight: Bool = false
        var extendDelimitersToTheLeft: Bool = false
        var applyProductFirstImageExtraPadding: Bool = false
        var reduceOnboardingShadows: Bool = false
        var drawBordersAroundConsents: Bool = false
        var displayProductPrices: Bool = true
        var loadingStatusStyle: Aiuta.Configuration.UserInterface.ComponentStyle = .blurred(hasOutline: false)
        var changePhotoButtonStyle: Aiuta.Configuration.UserInterface.ComponentStyle = .blurred(hasOutline: false)
        var activityIndicatorDelay: TimeInterval = 0.5.seconds
        var activityIndicatorDuration: TimeInterval = 1.5.seconds
    }
}

extension Sdk.Configuration.Styles {
    var modalPresentationStyle: UIModalPresentationStyle {
        switch presentationStyle {
            case .pageSheet, .bottomSheet: return .pageSheet
            case .fullScreen: return .fullScreen
        }
    }

    var isFullScreen: Bool {
        switch presentationStyle {
            case .pageSheet, .bottomSheet: return false
            case .fullScreen: return true
        }
    }

    var shoudInsetContentFromTop: Bool {
        isFullScreen
    }

    var allowViewControllersStackUp: Bool {
        switch presentationStyle {
            case .pageSheet, .fullScreen: return true
            case .bottomSheet: return false
        }
    }
}

extension Aiuta.Configuration.UserInterface.ComponentStyle {
    var backgroundColor: UIColor {
        @Injected var ds: DesignSystem
        switch self {
            case .brand: return ds.colors.brand
            case let .contrast(style):
                switch style {
                    case .lightOnDark: return ds.colors.onLight
                    case .darkOnLight: return ds.colors.onDark
                }
            case .blurred: return .clear
        }
    }

    var foregroundColor: UIColor {
        @Injected var ds: DesignSystem
        switch self {
            case .brand: return ds.colors.onDark
            case let .contrast(style):
                switch style {
                    case .lightOnDark: return ds.colors.onDark
                    case .darkOnLight: return ds.colors.onLight
                }
            case .blurred: return ds.colors.primary
        }
    }

    @MainActor func applyBlur(_ blur: Blur) {
        switch self {
            case .brand, .contrast:
                blur.view.isVisible = false
            case let .blurred(hasOutline):
                @Injected var ds: DesignSystem
                blur.style = ds.colors.scheme.blurStyle
                if hasOutline {
                    blur.view.borderColor = ds.colors.outline
                    blur.view.borderWidth = 1
                } else {
                    blur.view.borderWidth = 0
                }
                blur.view.isVisible = true
        }
    }
}
