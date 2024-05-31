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

struct SdkRussianLanguage: SdkLanguage {
    // General
    let tryOn = "Примерить" // Try on
    let share = "Поделиться" // Share
    let addToCart = "Добавить в корзину" // Add to cart
    let addToWishlist = "В избранное" // Add to wishlist
    let moreDetails = "Подробнее" // More details
    let somethingWrong = "Что-то пошло не так" // Something went wrong
    let tryAgain = "Что-то пошло не так.\nПожалуйста, повторите попытку позже" // Something went wrong. Please try again later
    let poweredBy = "Powered by" // Powered by
    let aiuta = "Aiuta"

    // App bar
    let history = "История" // History
    let select = "Выбрать" // Select
    let cancel = "Отмена" // Cancel

    // Onboarding
    let next = "Далее" // Next
    let start = "Начать" // Start

    let onboardingTryonTitle = "Примерьте перед покупкой" // Try on before buying
    let onboardingTryonDescription = "Загрузите своё фото и\nпорадуйтесь новому образу" // Just upload your photo and see how it looks

    let onboardingBestResultsTitle = "Для лучшего качества примерки" // For best results
    let onboardingBestResultsDescription = "Используйте фото с хорошим освещением и прямой позой" // Use a photo with good lighting, stand straight a plain background

    // Image selector
    let imageSelectorUploadButton = "Загрузить своё фото" // Upload a photo of you
    let imageSelectorChangeButton = "Заменить фото" // Change photo
    let imageSelectorPhotos: Pluralize = { "\($0) фото" } // N photos

    // Generation
    let generatingUpload = "Загружаем фото" // Uploading image
    let generatingScanBody = "Примеряем" // Scanning your body
    let generatingOutfit = "Генерируем образ" // Generating outfit

    // History
    let selectAll = "Выбрать все" // Select all
    let selectNone = "Снять выделение" // Select none
    let historyEmptyDescription = "История ваших примерок\nбудет сохранена здесь" // Once you try on first item your try-on history would be stored here

    // Generation Result
    let generationResultMoreTitle = "Больше образов для примерки" // More for you to try on
    let generationResultSwipeUp = "Посмотреть новые образы" // Swipe up for more

    // Picker sheet
    let pickerSheetTakePhoto = "Сделать фото" // Take a photo
    let pickerSheetChooseLibrary = "Выбрать из галереи" // Choose from library

    // Upload history sheet
    let uploadHistorySheetPreviously = "Ранее использованные фото" // Previously used photos
    let uploadHistorySheetUploadNewButton = "+ Загрузить новое фото" // + Upload new photo
}
