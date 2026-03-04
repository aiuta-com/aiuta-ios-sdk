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

#if SWIFT_PACKAGE
@_spi(Aiuta) import AiutaAssets
import AiutaConfig
import AiutaCore
#endif
import UIKit

extension Sdk.Theme {
    struct Icons {
        let config: Aiuta.Configuration
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }
        private var features: Aiuta.Configuration.Features { config.features }

        // MARK: - PageBar

        var back24: UIImage? { theme.pageBar.icons.back24 }
        var close24: UIImage? { theme.pageBar.icons.close24 }

        // MARK: - Selection

        var trash24: UIImage? { theme.selectionSnackbar.icons.trash24 }
        var check20: UIImage? { theme.selectionSnackbar.icons.check20 }

        // MARK: - Error

        var error36: UIImage? { theme.errorSnackbar.icons.error36 }

        // MARK: - Image

        var imageError36: UIImage? { theme.image.icons.imageError36 }

        // MARK: - ProductBar

        var arrow16: UIImage? { theme.productBar.icons.arrow16 }

        // MARK: - ActivityIndicator

        var loading14: UIImage? { theme.activityIndicator.icons.loading14 }

        // MARK: - Welcome Screen

        var welcome82: UIImage? { features.welcomeScreen?.icons.welcome82 }

        // MARK: - Onboarding

        var onboardingBestResultsGood24: UIImage? { features.onboarding?.bestResults?.icons.onboardingBestResultsGood24 }
        var onboardingBestResultsBad24: UIImage? { features.onboarding?.bestResults?.icons.onboardingBestResultsBad24 }

        // MARK: - Consent

        var consentTitle24: UIImage? { features.consent.standalone?.icons.consentTitle24 }

        // MARK: - ImagePicker.Camera

        var camera24: UIImage? { features.imagePicker.camera?.icons.camera24 }

        // MARK: - ImagePicker.Gallery

        var gallery24: UIImage? { features.imagePicker.photoGallery.icons.gallery24 }

        // MARK: - ImagePicker.PredefinedModel

        var selectModels24: UIImage? { features.imagePicker.predefinedModels?.icons.selectModels24 }

        // MARK: - ImagePicker.ProtectionDisclaimer

        var protection16: UIImage? { features.imagePicker.protectionDisclaimer?.icons.protection16 }

        // MARK: - TryOn

        var magic20: UIImage? { features.tryOn.icons.magic20 }

        // MARK: - Size&Fit

        var sizeFit24: UIImage? { AiutaAssets.bundleImage("aiutaIcon24SizeFit") }
        var female20: UIImage? { AiutaAssets.bundleImage("aiutaIcon20Female") }
        var male20: UIImage? { AiutaAssets.bundleImage("aiutaIcon20Male") }

        // MARK: - TryOn.FitDisclaimer

        var info20: UIImage? { features.tryOn.fitDisclaimer?.icons.info20 }

        // MARK: - TryOn.Feedback

        var like36: UIImage? { features.tryOn.feedback?.icons.like36 }
        var dislike36: UIImage? { features.tryOn.feedback?.icons.dislike36 }
        var gratitude40: UIImage? { features.tryOn.feedback?.icons.gratitude40 }

        // MARK: - TryOn.OtherPhoto

        var changePhoto24: UIImage? { features.tryOn.otherPhoto?.icon.changePhoto24 }

        // MARK: - TryOn.History

        var history24: UIImage? { features.tryOn.generationsHistory?.icons.history24 }

        // MARK: - Share

        var share24: UIImage? { features.share?.icons.share24 }

        // MARK: - Wishlist

        var wishlist24: UIImage? { features.wishlist?.icons.wishlist24 }
        var wishlistFill24: UIImage? { features.wishlist?.icons.wishlistFill24 }
    }
}
