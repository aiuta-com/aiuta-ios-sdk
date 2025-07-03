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

extension Sdk.Configuration {
    struct Icons {
        // MARK: - PageBar

        var back24: UIImage? = .bundleImage("aiutaIcon24Back")
        var close24: UIImage? = .bundleImage("aiutaIcon24Close")

        // MARK: - Selection

        var trash24: UIImage? = .bundleImage("aiutaIcon24Trash")
        var check20: UIImage? = .bundleImage("aiutaIcon20Check")

        // MARK: - Error

        var error36: UIImage? = .bundleImage("aiutaIcon36Error")

        // MARK: - Image

        var imageError36: UIImage? = .bundleImage("aiutaIcon36ImageError")

        // MARK: - ProductBar

        var arrow16: UIImage? = .bundleImage("aiutaIcon16Arrow")
        
        // MARK: - ActivityIndicator

        var loading14: UIImage?

        // MARK: - Welcome Screen

        var welcome82: UIImage?

        // MARK: - Onboarding

        var onboardingBestResultsGood24: UIImage?
        var onboardingBestResultsBad24: UIImage?

        // MARK: - Consent

        var consentTitle24: UIImage?

        // MARK: - ImagePicker.Camera

        var camera24: UIImage? = .bundleImage("aiutaIcon24Camera")

        // MARK: - ImagePicker.Gallery

        var gallery24: UIImage? = .bundleImage("aiutaIcon24Gallery")

        // MARK: - ImagePicker.PredefinedModel

        var selectModels24: UIImage? = .bundleImage("aiutaIcon24Model")

        // MARK: - TryOn

        var magic20: UIImage? = .bundleImage("aiutaIcon20Magic")

        // MARK: - TryOn.FitDisclaimer

        var info20: UIImage?

        // MARK: - TryOn.Feedback

        var like36: UIImage? = .bundleImage("aiutaIcon36Like")
        var dislike36: UIImage? = .bundleImage("aiutaIcon36Dislike")
        var gratitude40: UIImage?

        // MARK: - TryOn.OtherPhoto

        var changePhoto24: UIImage? = .bundleImage("aiutaIcon24CameraSwap")

        // MARK: - TryOn.History

        var history24: UIImage? = .bundleImage("aiutaIcon24History")

        // MARK: - Share

        var share24: UIImage? = .bundleImage("aiutaIcon24Share")

        // MARK: - Wishlist

        var wishlist24: UIImage? = .bundleImage("aiutaIcon24Wishlist")
        var wishlistFill24: UIImage? = .bundleImage("aiutaIcon24WishlistFill")
    }
}
