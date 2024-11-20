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

struct SdkTurkishLanguage: SdkLanguage {
    subscript(_ variants: Aiuta.StringVariants?) -> String? { variants?.tr }

    // General
    let tryOn = "Üzerinde Dene" // Try on
    let share = "Paylaş" // Share
    let addToCart = "Sepete ekle" // Add to cart
    let addToWishlist = "Listelerime ekle" // Add to wishlist
    let moreDetails = "Daha fazla detay" // More details
    let somethingWrong = "Bir şeyler yanlış gitti" // Something went wrong
    let tryAgain = "Bir şeyler yanlış gitti.\nLütfen daha sonra tekrar deneyin" // Something went wrong. Please try again later
    let poweredBy = "Tarafından desteklenmektedir" // Powered by
    let aiuta = "Aiuta"
    let settings = "Ayarlar" // Settings
    let cancel = "İptal" // Cancel
    let send = "Gönder" // Send
    let skip = "Atla" // Skip

    // App bar
    let history = "Geçmiş" // History
    let select = "Seç" // Select

    // Onboarding
    let next = "Başla" // Next
    let start = "Devam Et" // Start

    let onboardingTryonTitle = "Satın almadan önce dene" // Try on before buying
    let onboardingTryonDescription = "Fotoğrafını yükle ve\nüzerinde nasıl göründüğüne bak" // Just upload your photo and see how it looks

    let onboardingBestResultsTitle = "En iyi sonuçlar için" // For best results
    let onboardingBestResultsDescription = "İyi ışıklandırılmış, düz bir arka planı olan,\n dik durduğunuz bir fotoğraf kullanın" // Use a photo with good lighting, stand straight a plain background
    let onboardingLegalDisclaimer = "Fotoğrafınız <u>Aydınlatma Metni'nde</u> belirtilen kapsamda işlenmektedir" // Your photo is processed as per the Clarification Text

    // Image selector
    let imageSelectorUploadButton = "Fotoğrafını yükle" // Upload a photo of you
    let imageSelectorChangeButton = "Fotoğrafını değiştir" // Change photo
    let imageSelectorPhotos: Pluralize = { "\($0) fotoğraflar" } // N photos
    let imageSelectorCameraPermission = "Lütfen uygulama ayarlarından kameraya erişime izin verin." // Please allow access to the camera in the application settings.

    // Generation
    let generatingUpload = "Fotoğraf yükleniyor" // Uploading image
    let generatingScanBody = "Fotoğrafınız taranıyor" // Scanning your body
    let generatingOutfit = "Ürün uygulanıyor" // Generating outfit

    // History
    let selectAll = "Tümünü seçin" // Select all
    let selectNone = "Tümünü Kaldır" // Select none
    let historyEmptyDescription = "İlk ürün denemenizden sonra deneme\ngeçmişiniz burada saklanacaktır" // Once you try on first item your try-on history would be stored here

    // Generation Result
    let generationResultMoreTitle = "Denemeniz için daha fazlası" // More for you to try on
    let generationResultSwipeUp = "Daha fazlası için yukarı kaydır" // Swipe up for more

    // Picker sheet
    let pickerSheetTakePhoto = "Fotoğraf çek" // Take a photo
    let pickerSheetChooseLibrary = "Galeriden seç" // Choose from library

    // Upload history sheet
    let uploadHistorySheetPreviously = "Önceden yüklenen fotoğraflar" // Previously used photos
    let uploadHistorySheetUploadNewButton = "+ Yeni fotoğraf yükle" // + Upload new photo

    // Feedback
    let feedbackSend = "Geri bildirimi gönder" // Send feedback
    let feedbackCancel = "Vazgeç" // Cancel
}
