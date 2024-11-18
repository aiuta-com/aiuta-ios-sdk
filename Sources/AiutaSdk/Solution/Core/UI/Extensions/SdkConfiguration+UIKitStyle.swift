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

import UIKit

extension Aiuta.Configuration.Appearance.PresentationStyle {
    var modalPresentationStyle: UIModalPresentationStyle {
        switch self {
            case .pageSheet, .bottomSheet: return .pageSheet
            case .fullScreen: return .fullScreen
        }
    }

    var shoudInsetContentFromTop: Bool {
        isFullScreen
    }

    var allowViewControllersStackUp: Bool {
        switch self {
            case .pageSheet, .fullScreen: return true
            case .bottomSheet: return false
        }
    }

    var isFullScreen: Bool {
        switch self {
            case .pageSheet, .bottomSheet: return false
            case .fullScreen: return true
        }
    }
}

extension Aiuta.Configuration.Appearance.Style {
    var userInterface: UIUserInterfaceStyle {
        switch self {
            case .light: return .light
            case .dark: return .dark
        }
    }
}
