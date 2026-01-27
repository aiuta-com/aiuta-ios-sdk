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
import UIKit

extension Sdk {
    static func apply(_ preset: Aiuta.Configuration, to config: inout Sdk.Configuration) {
        config.apply(auth: preset.auth)
        config.apply(userInterface: preset.userInterface)
        config.apply(features: preset.features)
        config.apply(analytics: preset.analytics)
        config.apply(debugSettings: preset.debugSettings)
    }
}

// MARK: - GENERATED CODE

private extension Sdk.Configuration {
    mutating func apply(auth: Aiuta.Auth) {
        self.auth.type = auth
    }

    mutating func apply(userInterface: Aiuta.Configuration.UserInterface) {
        styles.presentationStyle = userInterface.presentationStyle
        styles.swipeToDismissPolicy = userInterface.swipeToDismissPolicy
        apply(theme: userInterface.theme)
    }

    mutating func apply(theme: Aiuta.Configuration.UserInterface.Theme) {
        apply(colorTheme: theme.color)
        apply(labelTheme: theme.label)
        apply(imageTheme: theme.image)
        apply(buttonTheme: theme.button)
        apply(pageBarTheme: theme.pageBar)
        apply(bottomSheetTheme: theme.bottomSheet)
        apply(activityIndicatorTheme: theme.activityIndicator)
        apply(selectionSnackbarTheme: theme.selectionSnackbar)
        apply(errorSnackbarTheme: theme.errorSnackbar)
        apply(productBarTheme: theme.productBar)
        apply(powerBarTheme: theme.powerBar)
    }

    mutating func apply(colorTheme: Aiuta.Configuration.UserInterface.ColorTheme) {
        colors.scheme = colorTheme.scheme
        colors.brand = colorTheme.brand
        colors.primary = colorTheme.primary
        colors.secondary = colorTheme.secondary
        colors.onDark = colorTheme.onDark
        colors.onLight = colorTheme.onLight
        colors.background = colorTheme.background
        colors.screen = colorTheme.screen ?? colors.screen
        colors.neutral = colorTheme.neutral
        colors.border = colorTheme.border
        colors.outline = colorTheme.outline
    }

    mutating func apply(labelTheme: Aiuta.Configuration.UserInterface.LabelTheme) {
        fonts.titleL = .init(labelTheme.typography.titleL)
        fonts.titleM = .init(labelTheme.typography.titleM)
        fonts.regular = .init(labelTheme.typography.regular)
        fonts.subtle = .init(labelTheme.typography.subtle)
    }

    mutating func apply(imageTheme: Aiuta.Configuration.UserInterface.ImageTheme) {
        self.shapes.imageL = imageTheme.shapes.imageL
        self.shapes.imageM = imageTheme.shapes.imageM
        self.icons.imageError36 = imageTheme.icons.imageError36
    }

    mutating func apply(buttonTheme: Aiuta.Configuration.UserInterface.ButtonTheme) {
        fonts.buttonM = .init(buttonTheme.typography.buttonM)
        fonts.buttonS = .init(buttonTheme.typography.buttonS)
        self.shapes.buttonM = buttonTheme.shapes.buttonM
        self.shapes.buttonS = buttonTheme.shapes.buttonS
    }

    mutating func apply(pageBarTheme: Aiuta.Configuration.UserInterface.PageBarTheme) {
        fonts.pageTitle = .init(pageBarTheme.typography.pageTitle)
        self.icons.back24 = pageBarTheme.icons.back24
        self.icons.close24 = pageBarTheme.icons.close24
        styles.preferCloseButtonOnTheRight = pageBarTheme.settings.preferCloseButtonOnTheRight
    }

    mutating func apply(bottomSheetTheme: Aiuta.Configuration.UserInterface.BottomSheetTheme) {
        fonts.iconButton = .init(bottomSheetTheme.typography.iconButton)
        self.shapes.bottomSheet = bottomSheetTheme.shapes.bottomSheet
        self.shapes.grabberWidth = bottomSheetTheme.grabber.width
        self.shapes.grabberHeight = bottomSheetTheme.grabber.height
        self.shapes.grabberOffset = bottomSheetTheme.grabber.offset
        styles.extendDelimitersToTheRight = bottomSheetTheme.settings.extendDelimitersToTheRight
        styles.extendDelimitersToTheLeft = bottomSheetTheme.settings.extendDelimitersToTheLeft
    }

    mutating func apply(activityIndicatorTheme: Aiuta.Configuration.UserInterface.ActivityIndicatorTheme) {
        self.icons.loading14 = activityIndicatorTheme.icons.loading14
        self.colors.activityOverlay = activityIndicatorTheme.colors.overlay
        styles.activityIndicatorDelay = TimeInterval(activityIndicatorTheme.settings.indicationDelay) / 1000
        styles.activityIndicatorDuration = TimeInterval(activityIndicatorTheme.settings.spinDuration) / 1000
    }

    mutating func apply(selectionSnackbarTheme: Aiuta.Configuration.UserInterface.SelectionSnackbarTheme) {
        self.strings.select = selectionSnackbarTheme.strings.select
        self.strings.cancel = selectionSnackbarTheme.strings.cancel
        self.strings.selectAll = selectionSnackbarTheme.strings.selectAll
        self.strings.unselectAll = selectionSnackbarTheme.strings.unselectAll
        self.icons.trash24 = selectionSnackbarTheme.icons.trash24
        self.icons.check20 = selectionSnackbarTheme.icons.check20
        self.colors.selectionBackground = selectionSnackbarTheme.colors.selectionBackground
    }

    mutating func apply(errorSnackbarTheme: Aiuta.Configuration.UserInterface.ErrorSnackbarTheme) {
        self.strings.defaultErrorMessage = errorSnackbarTheme.strings.defaultErrorMessage
        self.strings.tryAgainButton = errorSnackbarTheme.strings.tryAgainButton
        self.icons.error36 = errorSnackbarTheme.icons.error36
        self.colors.errorBackground = errorSnackbarTheme.colors.errorBackground
        self.colors.errorPrimary = errorSnackbarTheme.colors.errorPrimary
    }

    mutating func apply(productBarTheme: Aiuta.Configuration.UserInterface.ProductBarTheme) {
        self.icons.arrow16 = productBarTheme.icons.arrow16
        fonts.product = .init(productBarTheme.typography.product)
        fonts.brand = .init(productBarTheme.typography.brand)
        styles.applyProductFirstImageExtraPadding = productBarTheme.settings.applyProductFirstImageExtraPadding
        
        if let prices = productBarTheme.prices {
            styles.displayProductPrices = true
            fonts.price = .init(prices.typography.price)
            self.colors.discountedPrice = prices.colors.discountedPrice
        } else {
            styles.displayProductPrices = false
        }
    }

    mutating func apply(powerBarTheme: Aiuta.Configuration.UserInterface.PowerBarTheme) {
        self.strings.poweredByAiuta = powerBarTheme.strings.poweredByAiuta
        switch powerBarTheme.colors.aiuta {
            case .default:
                break
            case .primary:
                self.colors.aiuta = self.colors.primary
        }
    }

    mutating func apply(features: Aiuta.Configuration.Features) {
        apply(welcomeScreen: features.welcomeScreen)
        apply(onboarding: features.onboarding)
        apply(consent: features.consent)
        apply(imagePicker: features.imagePicker)
        apply(tryOn: features.tryOn)
        apply(share: features.share)
        apply(wishlist: features.wishlist)
        self.features.sizeFit = features.sizeFit
    }

    mutating func apply(welcomeScreen: Aiuta.Configuration.Features.WelcomeScreen?) {
        guard let welcomeScreen else {
            features.welcomeScreen.isEnabled = false
            return
        }
        
        features.welcomeScreen.isEnabled = true
        self.images.welcomeBackground = welcomeScreen.images.welcomeBackground
        self.icons.welcome82 = welcomeScreen.icons.welcome82
        self.strings.welcomeTitle = welcomeScreen.strings.welcomeTitle
        self.strings.welcomeDescription = welcomeScreen.strings.welcomeDescription
        self.strings.welcomeButtonStart = welcomeScreen.strings.welcomeButtonStart
        fonts.welcomeTitle = .init(welcomeScreen.typography.welcomeTitle)
        fonts.welcomeDescription = .init(welcomeScreen.typography.welcomeDescription)
    }

    mutating func apply(onboarding: Aiuta.Configuration.Features.Onboarding?) {
        guard let onboarding else {
            features.onboarding.isEnabled = false
            return
        }
        
        features.onboarding.isEnabled = true
        apply(onboardingHowItWorks: onboarding.howItWorks)
        apply(onboardingBestResults: onboarding.bestResults)
        
        self.strings.onboardingButtonNext = onboarding.strings.onboardingButtonNext
        self.strings.onboardingButtonStart = onboarding.strings.onboardingButtonStart
        
        self.shapes.onboardingImageL = onboarding.shapes.onboardingImageL
        self.shapes.onboardingImageS = onboarding.shapes.onboardingImageS
        
        switch onboarding.data {
            case .userDefaults:
                break
            case let .dataProvider(provider):
                features.onboarding.dataProvider = provider
        }
    }

    mutating func apply(onboardingHowItWorks: Aiuta.Configuration.Features.Onboarding.HowItWorks) {
        if !onboardingHowItWorks.images.onboardingHowItWorksItems.isEmpty {
            self.images.onboardingHowItWorksItems = onboardingHowItWorks.images.onboardingHowItWorksItems.map { item in
                (photo: item.itemPhoto, preview: item.itemPreview)
            }
        }
        
        self.strings.onboardingHowItWorksPageTitle = onboardingHowItWorks.strings.onboardingHowItWorksPageTitle
        self.strings.onboardingHowItWorksTitle = onboardingHowItWorks.strings.onboardingHowItWorksTitle
        self.strings.onboardingHowItWorksDescription = onboardingHowItWorks.strings.onboardingHowItWorksDescription
    }

    mutating func apply(onboardingBestResults: Aiuta.Configuration.Features.Onboarding.BestResults?) {
        guard let bestResults = onboardingBestResults else {
            features.onboarding.hasBestResults = false
            return
        }
        
        features.onboarding.hasBestResults = true
        self.images.onboardingBestResultsGood = bestResults.images.onboardingBestResultsGood
        self.images.onboardingBestResultsBad = bestResults.images.onboardingBestResultsBad
        self.icons.onboardingBestResultsGood24 = bestResults.icons.onboardingBestResultsGood24
        self.icons.onboardingBestResultsBad24 = bestResults.icons.onboardingBestResultsBad24
        self.strings.onboardingBestResultsPageTitle = bestResults.strings.onboardingBestResultsPageTitle
        self.strings.onboardingBestResultsTitle = bestResults.strings.onboardingBestResultsTitle
        self.strings.onboardingBestResultsDescription = bestResults.strings.onboardingBestResultsDescription
        styles.reduceOnboardingShadows = bestResults.toggles.reduceShadows
    }

    mutating func apply(consent: Aiuta.Configuration.Features.Consent) {
        switch consent {
            case .none:
                features.consent.isEmbedded = false
            case let .embeddedIntoOnboarding(embedded):
                self.strings.consentHtml = embedded.strings.consentHtml
            case let .standaloneOnboardingPage(standalone):
                features.consent.isEmbedded = false
                features.consent.isOnboarding = true
                
                self.strings.consentPageTitle = standalone.strings.consentPageTitle
                self.strings.consentTitle = standalone.strings.consentTitle
                self.strings.consentDescriptionHtml = standalone.strings.consentDescriptionHtml
                self.strings.consentFooterHtml = standalone.strings.consentFooterHtml
                self.strings.consentButtonAccept = standalone.strings.consentButtonAccept
                self.strings.consentButtonReject = standalone.strings.consentButtonReject
                
                self.icons.consentTitle24 = standalone.icons.consentTitle24
                self.styles.drawBordersAroundConsents = standalone.styles.drawBordersAroundConsents
                
                switch standalone.data {
                    case let .userDefaults(consents):
                        features.consent.consents = consents
                    case let .userDefaultsWithCallback(consents, onObtain):
                        features.consent.consents = consents
                        features.consent.onObtain = onObtain
                    case let .dataProvider(consents, provider):
                        features.consent.consents = consents
                        features.consent.dataProvider = provider
                }
            case let .standaloneImagePickerPage(standalone):
                features.consent.isEmbedded = false
                features.consent.isUploadButton = true
                
                self.strings.consentPageTitle = standalone.strings.consentPageTitle
                self.strings.consentTitle = standalone.strings.consentTitle
                self.strings.consentDescriptionHtml = standalone.strings.consentDescriptionHtml
                self.strings.consentFooterHtml = standalone.strings.consentFooterHtml
                self.strings.consentButtonAccept = standalone.strings.consentButtonAccept
                self.strings.consentButtonReject = standalone.strings.consentButtonReject
                
                self.icons.consentTitle24 = standalone.icons.consentTitle24
                self.styles.drawBordersAroundConsents = standalone.styles.drawBordersAroundConsents
                
                switch standalone.data {
                    case let .userDefaults(consents):
                        features.consent.consents = consents
                    case let .userDefaultsWithCallback(consents, onObtain):
                        features.consent.consents = consents
                        features.consent.onObtain = onObtain
                    case let .dataProvider(consents, provider):
                        features.consent.consents = consents
                        features.consent.dataProvider = provider
                }
        }
    }

    mutating func apply(imagePicker: Aiuta.Configuration.Features.ImagePicker) {
        apply(camera: imagePicker.camera)
        apply(gallery: imagePicker.photoGallery)
        apply(predefinedModel: imagePicker.predefinedModels)
        apply(uploadsHistory: imagePicker.uploadsHistory)
        
        if !imagePicker.images.imagePickerExamples.isEmpty {
            self.images.imagePickerExamples = imagePicker.images.imagePickerExamples
        }
        
        self.strings.imagePickerTitle = imagePicker.strings.imagePickerTitle
        self.strings.imagePickerDescription = imagePicker.strings.imagePickerDescription
        self.strings.imagePickerButtonUploadPhoto = imagePicker.strings.imagePickerButtonUploadPhoto
    }

    mutating func apply(camera: Aiuta.Configuration.Features.ImagePicker.Camera?) {
        guard let camera else {
            features.imagePicker.hasCamera = false
            return
        }
        
        features.imagePicker.hasCamera = true
        self.icons.camera24 = camera.icons.camera24
        self.strings.cameraButtonTakePhoto = camera.strings.cameraButtonTakePhoto
        self.strings.cameraPermissionTitle = camera.strings.cameraPermissionTitle
        self.strings.cameraPermissionDescription = camera.strings.cameraPermissionDescription
        self.strings.cameraPermissionButtonOpenSettings = camera.strings.cameraPermissionButtonOpenSettings
    }

    mutating func apply(gallery: Aiuta.Configuration.Features.ImagePicker.Gallery) {
        self.icons.gallery24 = gallery.icons.gallery24
        self.strings.galleryButtonSelectPhoto = gallery.strings.galleryButtonSelectPhoto
    }

    mutating func apply(predefinedModel: Aiuta.Configuration.Features.ImagePicker.PredefinedModels?) {
        guard let predefinedModel else {
            features.imagePicker.hasPredefinedModels = false
            return
        }
        
        features.imagePicker.hasPredefinedModels = true
        features.imagePicker.preferredPredefinedModelsCategoryId = predefinedModel.data.preferredCategoryId
        self.icons.selectModels24 = predefinedModel.icons.selectModels24
        self.strings.predefinedModelsTitle = predefinedModel.strings.predefinedModelsTitle
        self.strings.predefinedModelsOr = predefinedModel.strings.predefinedModelsOr
        self.strings.predefinedModelsEmptyListError = predefinedModel.strings.predefinedModelsEmptyListError
        self.strings.predefinedModelsCategories = predefinedModel.strings.predefinedModelsCategories
    }

    mutating func apply(uploadsHistory: Aiuta.Configuration.Features.ImagePicker.UploadsHistory?) {
        guard let uploadsHistory else {
            features.imagePicker.hasUploadsHistory = false
            return
        }
        
        features.imagePicker.hasUploadsHistory = true
        self.strings.uploadsHistoryButtonNewPhoto = uploadsHistory.strings.uploadsHistoryButtonNewPhoto
        self.strings.uploadsHistoryTitle = uploadsHistory.strings.uploadsHistoryTitle
        self.strings.uploadsHistoryButtonChangePhoto = uploadsHistory.strings.uploadsHistoryButtonChangePhoto
        self.styles.changePhotoButtonStyle = uploadsHistory.styles.changePhotoButtonStyle
        
        switch uploadsHistory.history {
            case .userDefaults:
                break
            case let .dataProvider(provider):
                features.imagePicker.historyProvider = provider
        }
    }

    mutating func apply(tryOn: Aiuta.Configuration.Features.TryOn) {
        apply(loadingPage: tryOn.loadingPage)
        apply(inputImageValidation: tryOn.inputImageValidation)
        if let cart = tryOn.cart {
            apply(cart: cart)
        }
        apply(fitDisclaimer: tryOn.fitDisclaimer)
        apply(feedback: tryOn.feedback)
        apply(generationsHistory: tryOn.generationsHistory)
        apply(otherPhoto: tryOn.otherPhoto)
        self.icons.magic20 = tryOn.icons.magic20
        colors.tryOnButtonGradient = tryOn.styles.tryOnButtonGradient
        self.strings.tryOnPageTitle = tryOn.strings.tryOnPageTitle
        self.strings.tryOn = tryOn.strings.tryOn
        features.tryOn.allowsBackgroundExecution = tryOn.toggles.allowsBackgroundExecution
        features.tryOn.tryGeneratePersonSegmentation = tryOn.toggles.tryGeneratePersonSegmentation
    }

    mutating func apply(loadingPage: Aiuta.Configuration.Features.TryOn.LoadingPage) {
        self.strings.tryOnLoadingStatusUploadingImage = loadingPage.strings.tryOnLoadingStatusUploadingImage
        self.strings.tryOnLoadingStatusScanningBody = loadingPage.strings.tryOnLoadingStatusScanningBody
        self.strings.tryOnLoadingStatusGeneratingOutfit = loadingPage.strings.tryOnLoadingStatusGeneratingOutfit
        colors.tryOnBackgroundGradient = loadingPage.styles.backgroundGradient
        self.styles.loadingStatusStyle = loadingPage.styles.statusStyle
    }

    mutating func apply(inputImageValidation: Aiuta.Configuration.Features.TryOn.InputValidation) {
        self.strings.invalidInputImageDescription = inputImageValidation.strings.invalidInputImageDescription
        self.strings.invalidInputImageChangePhotoButton = inputImageValidation.strings.invalidInputImageChangePhotoButton
    }

    mutating func apply(cart: Aiuta.Configuration.Features.TryOn.Cart) {
        features.tryOn.cartHandler = cart.handler
        self.strings.addToCart = cart.strings.addToCart
    }

    mutating func apply(fitDisclaimer: Aiuta.Configuration.Features.TryOn.FitDisclaimer?) {
        guard let fitDisclaimer else {
            features.tryOn.showsFitDisclaimerOnResults = false
            return
        }
        self.strings.fitDisclaimerTitle = fitDisclaimer.strings.fitDisclaimerTitle
        self.strings.fitDisclaimerDescription = fitDisclaimer.strings.fitDisclaimerDescription
        self.strings.fitDisclaimerCloseButton = fitDisclaimer.strings.fitDisclaimerCloseButton
        fonts.disclaimer = .init(fitDisclaimer.typography.disclaimer)
        if let info20 = fitDisclaimer.icons.info20 {
            self.icons.info20 = info20
        }
    }

    mutating func apply(feedback: Aiuta.Configuration.Features.TryOn.Feedback?) {
        guard let feedback else {
            features.tryOn.askForUserFeedbackOnResults = false
            return
        }
        self.strings.feedbackTitle = feedback.strings.feedbackTitle
        self.strings.feedbackOptions = feedback.strings.feedbackOptions
        self.strings.feedbackButtonSkip = feedback.strings.feedbackButtonSkip
        self.strings.feedbackButtonSend = feedback.strings.feedbackButtonSend
        self.strings.feedbackGratitudeText = feedback.strings.feedbackGratitudeText
        self.icons.like36 = feedback.icons.like36
        self.icons.dislike36 = feedback.icons.dislike36
        self.icons.gratitude40 = feedback.icons.gratitude40
        self.shapes.feedbackButton = feedback.shapes.feedbackButton
        if let other = feedback.other {
            self.strings.feedbackOptionOther = other.strings.feedbackOptionOther
            self.strings.otherFeedbackTitle = other.strings.otherFeedbackTitle
            self.strings.otherFeedbackButtonSend = other.strings.otherFeedbackButtonSend
            self.strings.otherFeedbackButtonCancel = other.strings.otherFeedbackButtonCancel
        } else {
            features.tryOn.askForOtherFeedbackOnResults = false
        }
    }

    mutating func apply(generationsHistory: Aiuta.Configuration.Features.TryOn.GenerationsHistory?) {
        guard let generationsHistory else {
            features.tryOn.hasGenerationsHistory = false
            return
        }
        self.icons.history24 = generationsHistory.icons.history24
        self.strings.generationsHistoryPageTitle = generationsHistory.strings.generationsHistoryPageTitle
        switch generationsHistory.history {
            case .userDefaults:
                break
            case let .dataProvider(provider):
                features.tryOn.historyProvider = provider
        }
    }

    mutating func apply(otherPhoto: Aiuta.Configuration.Features.TryOn.ContinueWithOtherPhoto) {
        icons.changePhoto24 = otherPhoto.icon.changePhoto24
    }

    mutating func apply(share: Aiuta.Configuration.Features.Share?) {
        guard let share else {
            features.share.isEnabled = false
            return
        }
        switch share.watermark {
            case .none:
                break
            case let .custom(shareWatermark):
                images.shareWatermark = shareWatermark
            case let .provider(provider):
                images.shareWatermark = provider.shareWatermark
        }
        switch share.text {
            case .none:
                break
            case let .dataProvider(provider):
                features.share.additionalTextProvider = provider
        }
        self.icons.share24 = share.icons.share24
        self.strings.shareButton = share.strings.shareButton
    }

    mutating func apply(wishlist: Aiuta.Configuration.Features.Wishlist?) {
        guard let wishlist else {
            features.wishlist.isEnabled = false
            return
        }
        features.wishlist.dataProvider = wishlist.dataProvider
        self.icons.wishlist24 = wishlist.icons.wishlist24
        self.icons.wishlistFill24 = wishlist.icons.wishlistFill24
        self.strings.wishlistButtonAdd = wishlist.strings.wishlistButtonAdd
    }

    mutating func apply(analytics: Aiuta.Analytics) {
        switch analytics {
            case .none:
                break
            case let .handler(handler):
                features.analytics.handler = handler
        }
    }

    mutating func apply(debugSettings: Aiuta.Configuration.DebugSettings) {
        settings.isLoggingEnabled = debugSettings.isLoggingEnabled
        settings.infoPlistDescriptionsPolicy = debugSettings.infoPlistDescriptionsPolicy
        settings.emptyStringsPolicy = debugSettings.emptyStringsPolicy
        settings.listSizePolicy = debugSettings.listSizePolicy
    }
}
