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

struct SdkTurkishLanguage: AiutaSdkLanguage {
    let substitutions: Aiuta.Localization.Builtin.Substitutions

    init(_ substitutions: Aiuta.Localization.Builtin.Substitutions) {
        self.substitutions = substitutions
    }

    let tryOn = "Deneyin"
    let close = "Kapat"
    let cancel = "İptal"
    let addToWish = "İstek Listesi"
    let addToCart = "Sepete Ekle"
    let share = "Paylaş"
    let tryAgain = "Tekrar deneyin"
    let defaultErrorMessage = "Bir şeyler ters gitti.\nLütfen daha sonra tekrar deneyin"

    // MARK: - App bar

    let appBarVirtualTryOn = "Sanal Deneme"
    let appBarHistory = "Geçmiş"
    let appBarSelect = "Seç"

    // MARK: - Splash

    let preOnboardingTitle = "Kendinizde deneyin"
    let preOnboardingSubtitle = "Sanal Denememize hoş geldiniz.\nÜrünü doğrudan\nfotoğrafınızda deneyin"
    let preOnboardingButton = "Başlayalım"

    // MARK: - Onboarding

    let onboardingAppbarTryonPage = "<b>Adım 1/3</b> - Nasıl çalışır"
    let onboardingPageTryonTopic = "Satın almadan önce deneyin"
    let onboardingPageTryonSubtopic = "Bir fotoğraf yükleyin ve ürünlerin üzerinizde nasıl göründüğünü görün"

    let onboardingAppbarBestResultPage = "<b>Adım 2/3</b> - En iyi sonuç için"
    let onboardingPageBestResultTopic = "En iyi sonuçlar için"
    let onboardingPageBestResultSubtopic = "İyi aydınlatmalı, düz bir arka plan önünde düz durduğunuz bir fotoğraf kullanın"

    let onboardingAppbarConsentPage = "<b>Adım 3/3</b> - Onay"
    let onboardingPageConsentTopic = "Onay"

    var onboardingPageConsentBody: String {
        "Ürünleri dijital olarak denemek için, \(substitutions.brandName)'ın fotoğrafınızı işlemesine izin vermeyi kabul edersiniz. " +
            "Verileriniz \(substitutions.brandName) <b><a href='\(substitutions.privacyPolicyUrl)'>Gizlilik Bildirimi</a></b> ve " +
            "<b><a href='\(substitutions.termsOfServiceUrl)'>Kullanım Şartları</a></b> uyarınca işlenecektir."
    }

    var onboardingPageConsentSupplementaryPoints: [String] {
        substitutions.supplementaryConsents
    }

    var onboardingPageConsentAgreePoint: String {
        "Fotoğrafımın işlenmesine \(substitutions.brandName)'a izin vermeyi kabul ediyorum"
    }

    let onboardingButtonNext = "İleri"
    let onboardingButtonStart = "Başla"

    // MARK: - Image selector

    let imageSelectorUploadButton = "Kendi fotoğrafınızı yükleyin"
    let imageSelectorChangeButton = "Fotoğrafı değiştir"
    let imageSelectorProtectionPoint = "Fotoğraflarınız korunur ve yalnızca&nbsp;sizin&nbsp;için&nbsp;görünür"
    let imageSelectorPoweredByAiuta = "Aiuta tarafından desteklenmektedir"

    // MARK: - Loading

    let loadingUploadingImage = "Görüntü yükleniyor"
    let loadingScanningBody = "Vücudunuz taranıyor"
    let loadingGeneratingOutfit = "Kıyafet oluşturuluyor"
    let dialogInvalidImageDescription = "Bu fotoğraftaki kimseyi tespit edemedik"

    // MARK: - Generation Result

    let generationResultMoreTitle = "Bunları da beğenebilirsiniz"
    let generationResultMoreSubtitle = "Denemeniz için daha fazlası"

    // MARK: - History

    let historySelectorEnableButtonSelectAll = "Hepsini seç"
    let historySelectorEnableButtonUnselectAll = "Seçimi kaldır"

    // MARK: - Photo picker sheet

    let pickerSheetTakePhoto = "Fotoğraf çek"
    let pickerSheetChooseLibrary = "Kütüphaneden seç"

    // MARK: - Uploads history sheet

    let uploadsHistorySheetPreviously = "Daha önce kullanılan fotoğraflar"
    let uploadsHistorySheetUploadNewButton = "+ Yeni fotoğraf yükle"

    // MARK: - Feedback sheet

    let feedbackSheetTitle = "Bize daha fazla bilgi verebilir misiniz?"
    let feedbackSheetOptions = ["Bu stil bana göre değil", "Ürün yanlış görünüyor", "Farklı görünüyorum"]
    let feedbackSheetSkip = "Atla"
    let feedbackSheetSend = "Gönder"

    let feedbackSheetExtraOption = "Diğer"
    let feedbackSheetExtraOptionTitle = "Ne geliştirebileceğimizi bize söyleyin?"
    let feedbackSheetSendFeedback = "Geri bildirim gönder"
    let feedbackSheetGratitude = "Geri bildiriminiz için teşekkür ederiz"

    // MARK: - Fit disclaimer

    let fitDisclaimerTitle = "Sonuçlar gerçek hayattaki uyumdan farklı olabilir"
    let fitDisclaimerBody = "Sanal deneme, ürünlerin nasıl görünebileceğini gösteren bir görselleştirme aracıdır ve ürünün gerçekte nasıl uyacağını mükemmel şekilde temsil etmeyebilir"

    // MARK: - Camera permission

    let dialogCameraPermissionTitle = "Kamera izni"
    let dialogCameraPermissionDescription = "Lütfen uygulama ayarlarından kameraya erişime izin verin"
    let dialogCameraPermissionConfirmButton = "Ayarlar"
}
