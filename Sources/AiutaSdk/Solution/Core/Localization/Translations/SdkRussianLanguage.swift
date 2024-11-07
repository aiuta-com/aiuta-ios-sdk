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

struct SdkRussianLanguage: AiutaSdkLanguage {
    let substitutions: Aiuta.Localization.Builtin.Substitutions

    init(_ substitutions: Aiuta.Localization.Builtin.Substitutions) {
        self.substitutions = substitutions
    }

    let tryOn = "Примерить"
    let close = "Закрыть"
    let cancel = "Отмена"
    let addToWish = "Список желаний"
    let addToCart = "Добавить в корзину"
    let share = "Поделиться"
    let tryAgain = "Попробовать снова"
    let defaultErrorMessage = "Что-то пошло не так.\nПожалуйста, попробуйте позже"

    // MARK: - App bar

    let appBarVirtualTryOn = "Виртуальная примерка"
    let appBarHistory = "История"
    let appBarSelect = "Выбрать"

    // MARK: - Splash

    let preOnboardingTitle = "Попробуйте на себе"
    let preOnboardingSubtitle = "Добро пожаловать в нашу виртуальную примерочную.\nПримерьте товар прямо\nна своей фотографии"
    let preOnboardingButton = "Начнем"

    // MARK: - Onboarding

    let onboardingAppbarTryonPage = "<b>Шаг 1/3</b> - Как это работает"
    let onboardingPageTryonTopic = "Примерьте перед покупкой"
    let onboardingPageTryonSubtopic = "Загрузите фото и посмотрите, как вещи выглядят на вас"

    let onboardingAppbarBestResultPage = "<b>Шаг 2/3</b> - Для лучшего результата"
    let onboardingPageBestResultTopic = "Для лучшего результата"
    let onboardingPageBestResultSubtopic = "Используйте фото с хорошим освещением, стойте прямо на однотонном фоне"

    let onboardingAppbarConsentPage = "<b>Шаг 3/3</b> - Согласие"
    let onboardingPageConsentTopic = "Согласие"

    var onboardingPageConsentBody: String {
        "Чтобы примерить товары в цифровом виде, вы соглашаетесь разрешить \(substitutions.brandName) обрабатывать вашу фотографию. " +
            "Ваши данные будут обработаны в соответствии с <b><a href='\(substitutions.privacyPolicyUrl)'>Политикой конфиденциальности</a></b> и <b><a href='\(substitutions.termsOfServiceUrl)'>Условиями использования</a></b> \(substitutions.brandName)."
    }

    var onboardingPageConsentAgreePoint: String {
        "Я даю согласие \(substitutions.brandName) на обработку моей фотографии"
    }

    let onboardingButtonNext = "Далее"
    let onboardingButtonStart = "Начать"

    // MARK: - Image selector

    let imageSelectorUploadButton = "Загрузить вашу фотографию"
    let imageSelectorChangeButton = "Изменить фотографию"
    let imageSelectorProtectionPoint = "Ваши фотографии защищены и видны только&nbsp;вам"
    let imageSelectorPoweredByAiuta = "Работает на базе Aiuta"

    // MARK: - Loading

    let loadingUploadingImage = "Загрузка изображения"
    let loadingScanningBody = "Сканирование вашего тела"
    let loadingGeneratingOutfit = "Создание образа"
    let dialogInvalidImageDescription = "Мы не смогли обнаружить\nникого на этом фото"

    // MARK: - Generation Result

    let generationResultMoreTitle = "Вам также может понравиться"
    let generationResultMoreSubtitle = "Еще варианты для примерки"

    // MARK: - History

    let historySelectorDisabledButton = "Выбрать"
    let historySelectorEnableButtonSelectAll = "Выбрать все"
    let historySelectorEnableButtonUnselectAll = "Снять выделение"
    let historySelectorEnableButtonCancel = "Отмена"

    // MARK: - Photo picker sheet

    let pickerSheetTakePhoto = "Сделать фото"
    let pickerSheetChooseLibrary = "Выбрать из библиотеки"

    // MARK: - Uploads history sheet

    let uploadsHistorySheetPreviously = "Ранее использованные фотографии"
    let uploadsHistorySheetUploadNewButton = "+ Загрузить новое фото"

    // MARK: - Feedback sheet

    let feedbackSheetTitle = "Можете рассказать подробнее?"
    let feedbackSheetOptions = ["Этот стиль не для меня", "Товар выглядит неправильно", "Я выгляжу по-другому"]
    let feedbackSheetSkip = "Пропустить"
    let feedbackSheetSend = "Отправить"

    let feedbackSheetExtraOption = "Другое"
    let feedbackSheetExtraOptionTitle = "Расскажите, что мы можем улучшить?"
    let feedbackSheetSendFeedback = "Отправить отзыв"
    let feedbackSheetGratitude = "Спасибо за ваш отзыв"

    // MARK: - Fit disclaimer

    let fitDisclaimerTitle = "Результаты могут отличаться от реальной посадки"
    let fitDisclaimerBody = "Виртуальная примерка — это инструмент визуализации, который показывает, как вещи могут выглядеть, и может не идеально отображать, как вещь будет сидеть в реальности"

    // MARK: - Camera permission

    let dialogCameraPermissionTitle = "Доступ к камере"
    let dialogCameraPermissionDescription = "Пожалуйста, разрешите доступ к камере в настройках приложения"
    let dialogCameraPermissionConfirmButton = "Настройки"
}
