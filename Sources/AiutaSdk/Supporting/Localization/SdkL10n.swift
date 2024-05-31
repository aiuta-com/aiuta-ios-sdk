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

import Foundation

fileprivate(set) var L: SdkLanguage = SdkEnglishLanguage()

func setLocalization(language: Aiuta.Configuration.Language?) {
    guard let language else {
        setSystemLanguage()
        return
    }

    switch language {
        case .English: L = SdkEnglishLanguage()
        case .Turkish: L = SdkTurkishLanguage()
        case .Russian: L = SdkRussianLanguage()
    }
}

private func setSystemLanguage() {
    switch getPrefferedLanguageCode() {
        case "ru": L = SdkRussianLanguage()
        case "tr": L = SdkTurkishLanguage()
        default: L = SdkEnglishLanguage()
    }
}

private func getPrefferedLanguageCode() -> String? {
    if let preffered = Locale.preferredLanguages.first?.split(separator: "-").first {
        return String(preffered)
    }
    if #available(iOS 16, *) {
        return Locale.current.language.languageCode?.identifier
    } else {
        return Locale.current.languageCode
    }
}
