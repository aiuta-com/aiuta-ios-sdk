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

protocol SdkLanguage {
    // General
    var tryOn: String { get }
    var share: String { get }
    var addToCart: String { get }
    var addToWishlist: String { get }
    var moreDetails: String { get }
    var somethingWrong: String { get }
    var tryAgain: String { get }
    var poweredBy: String { get }
    var aiuta: String { get }
    
    // App bar
    var history: String { get }
    var select: String { get }
    var cancel: String { get }

    // Onboarding
    var next: String { get }
    var start: String { get }
    var onboardingTryonTitle: String { get }
    var onboardingTryonDescription: String { get }
    var onboardingBestResultsTitle: String { get }
    var onboardingBestResultsDescription: String { get }

    // Image selector
    var imageSelectorUploadButton: String { get }
    var imageSelectorChangeButton: String { get }
    var imageSelectorPhotos: Pluralize { get }
    
    // Generation
    var generatingUpload: String { get }
    var generatingScanBody: String { get }
    var generatingOutfit: String { get }

    // History
    var selectAll: String { get }
    var selectNone: String { get }
    var historyEmptyDescription: String { get }

    // Generation Result
    var generationResultMoreTitle: String { get }
    var generationResultSwipeUp: String { get }

    // Picker sheet
    var pickerSheetTakePhoto: String { get }
    var pickerSheetChooseLibrary: String { get }

    // Upload history sheet
    var uploadHistorySheetPreviously: String { get }
    var uploadHistorySheetUploadNewButton: String { get }
}

typealias Pluralize = (_ count: Int) -> String
