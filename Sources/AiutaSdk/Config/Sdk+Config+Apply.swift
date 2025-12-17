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
        switch userInterface {
            case .default:
                break
            case let .custom(theme, presentationStyle, swipeToDismissPolicy):
                styles.presentationStyle = presentationStyle
                styles.swipeToDismissPolicy = swipeToDismissPolicy
                apply(theme: theme)
        }
    }

    mutating func apply(theme: Aiuta.Configuration.UserInterface.Theme) {
        switch theme {
            case .default:
                break
            case let .aiuta(scheme):
                colors.scheme = scheme
            case let .brand(scheme, brand):
                colors.scheme = scheme
                colors.brand = brand
            case let .custom(color, label, image, button, pageBar, bottomSheet, activityIndicator,
                             selectionSnackbar, errorSnackbar, productBar, powerBar):
                apply(colorTheme: color)
                apply(labelTheme: label)
                apply(imageTheme: image)
                apply(buttonTheme: button)
                apply(pageBarTheme: pageBar)
                apply(bottomSheetTheme: bottomSheet)
                apply(activityIndicatorTheme: activityIndicator)
                apply(selectionSnackbarTheme: selectionSnackbar)
                apply(errorSnackbarTheme: errorSnackbar)
                apply(productBarTheme: productBar)
                apply(powerBarTheme: powerBar)
        }
    }

    mutating func apply(colorTheme: Aiuta.Configuration.UserInterface.ColorTheme) {
        switch colorTheme {
            case .default:
                break
            case let .aiuta(scheme):
                colors.scheme = scheme
            case let .brand(scheme, brand):
                colors.scheme = scheme
                colors.brand = brand
            case let .custom(scheme, brand, primary, secondary, onDark, onLight,
                             background, screen, neutral, border, outline):
                colors.scheme = scheme
                colors.brand = brand
                colors.primary = primary
                colors.secondary = secondary
                colors.onDark = onDark
                colors.onLight = onLight
                colors.background = background
                colors.screen = screen ?? colors.screen
                colors.neutral = neutral
                colors.border = border
                colors.outline = outline
            case let .provider(provider):
                colors.scheme = provider.scheme
                colors.brand = provider.brand
                colors.primary = provider.primary
                colors.secondary = provider.secondary
                colors.onDark = provider.onDark
                colors.onLight = provider.onLight
                colors.background = provider.background
                colors.screen = provider.screen ?? colors.screen
                colors.neutral = provider.neutral
                colors.border = provider.border
                colors.outline = provider.outline
        }
    }

    mutating func apply(labelTheme: Aiuta.Configuration.UserInterface.LabelTheme) {
        switch labelTheme {
            case .default:
                break
            case let .custom(typography):
                switch typography {
                    case .default:
                        break
                    case let .custom(titleL, titleM, regular, subtle):
                        fonts.titleL = .init(titleL)
                        fonts.titleM = .init(titleM)
                        fonts.regular = .init(regular)
                        fonts.subtle = .init(subtle)
                    case let .provider(provider):
                        fonts.titleL = .init(provider.titleL)
                        fonts.titleM = .init(provider.titleM)
                        fonts.regular = .init(provider.regular)
                        fonts.subtle = .init(provider.subtle)
                }
        }
    }

    mutating func apply(imageTheme: Aiuta.Configuration.UserInterface.ImageTheme) {
        switch imageTheme {
            case .default:
                break
            case let .custom(shapes, icons):
                switch shapes {
                    case .default:
                        break
                    case .small:
                        self.shapes.imageL = .continuous(radius: 16)
                        self.shapes.imageM = .continuous(radius: 4)
                    case let .custom(imageL, imageM):
                        self.shapes.imageL = imageL
                        self.shapes.imageM = imageM
                    case let .provider(provider):
                        self.shapes.imageL = provider.imageL
                        self.shapes.imageM = provider.imageM
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(imageError36):
                        self.icons.imageError36 = imageError36
                    case let .provider(provider):
                        self.icons.imageError36 = provider.imageError36
                }
        }
    }

    mutating func apply(buttonTheme: Aiuta.Configuration.UserInterface.ButtonTheme) {
        switch buttonTheme {
            case .default:
                break
            case let .custom(typography, shapes):
                switch typography {
                    case .default:
                        break
                    case let .custom(buttonM, buttonS):
                        fonts.buttonM = .init(buttonM)
                        fonts.buttonS = .init(buttonS)
                    case let .provider(provider):
                        fonts.buttonM = .init(provider.buttonM)
                        fonts.buttonS = .init(provider.buttonS)
                }
                switch shapes {
                    case .default:
                        break
                    case .small:
                        self.shapes.buttonM = .continuous(radius: 4)
                        self.shapes.buttonS = .continuous(radius: 4)
                    case let .custom(buttonM, buttonS):
                        self.shapes.buttonM = buttonM
                        self.shapes.buttonS = buttonS
                    case let .provider(provider):
                        self.shapes.buttonM = provider.buttonM
                        self.shapes.buttonS = provider.buttonS
                }
        }
    }

    mutating func apply(pageBarTheme: Aiuta.Configuration.UserInterface.PageBarTheme) {
        switch pageBarTheme {
            case .default:
                break
            case let .custom(typography, icons, settings):
                switch typography {
                    case .default:
                        break
                    case let .custom(pageTitle):
                        fonts.pageTitle = .init(pageTitle)
                    case let .provider(provider):
                        fonts.pageTitle = .init(provider.pageTitle)
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(back24, close24):
                        self.icons.back24 = back24
                        self.icons.close24 = close24
                    case let .provider(provider):
                        self.icons.back24 = provider.back24
                        self.icons.close24 = provider.close24
                }
                switch settings {
                    case .default:
                        break
                    case let .custom(preferCloseButtonOnTheRight):
                        styles.preferCloseButtonOnTheRight = preferCloseButtonOnTheRight
                }
        }
    }

    mutating func apply(bottomSheetTheme: Aiuta.Configuration.UserInterface.BottomSheetTheme) {
        switch bottomSheetTheme {
            case .default:
                break
            case let .custom(typography, shapes, grabber, settings):
                switch typography {
                    case .default:
                        break
                    case let .custom(iconButton):
                        fonts.iconButton = .init(iconButton)
                    case let .provider(provider):
                        fonts.iconButton = .init(provider.iconButton)
                }
                switch shapes {
                    case .default:
                        break
                    case let .custom(bottomSheet):
                        self.shapes.bottomSheet = bottomSheet
                    case let .provider(provider):
                        self.shapes.bottomSheet = provider.bottomSheet
                }
                switch grabber {
                    case .default:
                        break
                    case let .custom(width, height, offset):
                        self.shapes.grabberWidth = width
                        self.shapes.grabberHeight = height
                        self.shapes.grabberOffset = offset
                    case .none:
                        self.shapes.grabberHeight = 0
                        self.shapes.grabberOffset = 0
                }
                switch settings {
                    case .default:
                        break
                    case let .presets(delimiters):
                        switch delimiters {
                            case .defaultInset:
                                break
                            case .extendToTheRight:
                                styles.extendDelimitersToTheRight = true
                            case .extendToTheLeftAndRight:
                                styles.extendDelimitersToTheRight = true
                                styles.extendDelimitersToTheLeft = true
                        }
                    case let .custom(extendDelimitersToTheRight, extendDelimitersToTheLeft):
                        styles.extendDelimitersToTheRight = extendDelimitersToTheRight
                        styles.extendDelimitersToTheLeft = extendDelimitersToTheLeft
                }
        }
    }

    mutating func apply(activityIndicatorTheme: Aiuta.Configuration.UserInterface.ActivityIndicatorTheme) {
        switch activityIndicatorTheme {
            case .default:
                break
            case let .custom(icons, colors, settings):
                switch icons {
                    case .system:
                        break
                    case let .custom(loading14):
                        self.icons.loading14 = loading14
                    case let .provider(provider):
                        self.icons.loading14 = provider.loading14
                }
                switch colors {
                    case .default:
                        break
                    case let .custom(overlay):
                        self.colors.activityOverlay = overlay
                    case let .provider(provider):
                        self.colors.activityOverlay = provider.overlay
                }
                switch settings {
                    case .default:
                        break
                    case let .custom(indicationDelay, spinDuration):
                        styles.activityIndicatorDelay = TimeInterval(indicationDelay) / 1000
                        styles.activityIndicatorDuration = TimeInterval(spinDuration) / 1000
                }
        }
    }

    mutating func apply(selectionSnackbarTheme: Aiuta.Configuration.UserInterface.SelectionSnackbarTheme) {
        switch selectionSnackbarTheme {
            case .default:
                break
            case let .custom(strings, icons, colors):
                switch strings {
                    case .default:
                        break
                    case let .custom(select, cancel, selectAll, unselectAll):
                        self.strings.select = select
                        self.strings.cancel = cancel
                        self.strings.selectAll = selectAll
                        self.strings.unselectAll = unselectAll
                    case let .provider(provider):
                        self.strings.select = provider.select
                        self.strings.cancel = provider.cancel
                        self.strings.selectAll = provider.selectAll
                        self.strings.unselectAll = provider.unselectAll
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(trash24, check20):
                        self.icons.trash24 = trash24
                        self.icons.check20 = check20
                    case let .provider(provider):
                        self.icons.trash24 = provider.trash24
                        self.icons.check20 = provider.check20
                }
                switch colors {
                    case .aiutaLight:
                        break
                    case let .custom(selectionBackground):
                        self.colors.selectionBackground = selectionBackground
                    case let .provider(provider):
                        self.colors.selectionBackground = provider.selectionBackground
                }
        }
    }

    mutating func apply(errorSnackbarTheme: Aiuta.Configuration.UserInterface.ErrorSnackbarTheme) {
        switch errorSnackbarTheme {
            case .default:
                break
            case let .custom(strings, icons, colors):
                switch strings {
                    case .default:
                        break
                    case let .custom(defaultErrorMessage, tryAgainButton):
                        self.strings.defaultErrorMessage = defaultErrorMessage
                        self.strings.tryAgainButton = tryAgainButton
                    case let .provider(provider):
                        self.strings.defaultErrorMessage = provider.defaultErrorMessage
                        self.strings.tryAgainButton = provider.tryAgainButton
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(error36):
                        self.icons.error36 = error36
                    case let .provider(provider):
                        self.icons.error36 = provider.error36
                }
                switch colors {
                    case .aiutaLight:
                        break
                    case let .custom(errorBackground, errorPrimary):
                        self.colors.errorBackground = errorBackground
                        self.colors.errorPrimary = errorPrimary
                    case let .provider(provider):
                        self.colors.errorBackground = provider.errorBackground
                        self.colors.errorPrimary = provider.errorPrimary
                }
        }
    }

    mutating func apply(productBarTheme: Aiuta.Configuration.UserInterface.ProductBarTheme) {
        switch productBarTheme {
            case .default:
                break
            case let .custom(icons, typography, settings, prices):
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(arrow16):
                        self.icons.arrow16 = arrow16
                    case let .provider(provider):
                        self.icons.arrow16 = provider.arrow16
                }
                switch typography {
                    case .default:
                        break
                    case let .custom(product, brand):
                        fonts.product = .init(product)
                        fonts.brand = .init(brand)
                    case let .provider(provider):
                        fonts.product = .init(provider.product)
                        fonts.brand = .init(provider.brand)
                }
                switch settings {
                    case .default:
                        break
                    case let .custom(applyProductFirstImageExtraPadding):
                        styles.applyProductFirstImageExtraPadding = applyProductFirstImageExtraPadding
                }
                switch prices {
                    case .default:
                        break
                    case .none:
                        styles.displayProductPrices = false
                    case let .custom(typography, colors):
                        switch typography {
                            case .default:
                                break
                            case let .custom(price):
                                fonts.price = .init(price)
                            case let .provider(provider):
                                fonts.price = .init(provider.price)
                        }
                        switch colors {
                            case .aiutaLight:
                                break
                            case let .custom(discountedPrice):
                                self.colors.discountedPrice = discountedPrice
                            case let .provider(provider):
                                self.colors.discountedPrice = provider.discountedPrice
                        }
                }
        }
    }

    mutating func apply(powerBarTheme: Aiuta.Configuration.UserInterface.PowerBarTheme) {
        switch powerBarTheme {
            case .default:
                break
            case let .custom(strings, colors):
                switch strings {
                    case .default:
                        break
                    case let .custom(poweredByAiuta):
                        self.strings.poweredByAiuta = poweredByAiuta
                    case let .provider(provider):
                        self.strings.poweredByAiuta = provider.poweredByAiuta
                }
                switch colors {
                    case .default, .custom(.default):
                        break
                    case .custom(.primary):
                        self.colors.aiuta = self.colors.primary
                    case let .provider(provider):
                        switch provider.aiuta {
                            case .default:
                                break
                            case .primary:
                                self.colors.aiuta = self.colors.primary
                        }
                }
        }
    }

    mutating func apply(features: Aiuta.Configuration.Features) {
        switch features {
            case .default:
                break
            case let .custom(welcomeScreen, onboarding, consent, imagePicker, tryOn, share, wishlist):
                apply(welcomeScreen: welcomeScreen)
                apply(onboarding: onboarding)
                apply(consent: consent)
                apply(imagePicker: imagePicker)
                apply(tryOn: tryOn)
                apply(share: share)
                apply(wishlist: wishlist)
        }
    }

    mutating func apply(welcomeScreen: Aiuta.Configuration.Features.WelcomeScreen) {
        switch welcomeScreen {
            case .none:
                features.welcomeScreen.isEnabled = false
            case let .custom(images, icons, strings, typography):
                features.welcomeScreen.isEnabled = true
                switch images {
                    case let .custom(welcomeBackground):
                        self.images.welcomeBackground = welcomeBackground
                    case let .provider(provider):
                        self.images.welcomeBackground = provider.welcomeBackground
                }
                switch icons {
                    case let .custom(welcome82):
                        self.icons.welcome82 = welcome82
                    case let .provider(provider):
                        self.icons.welcome82 = provider.welcome82
                }
                switch strings {
                    case let .custom(welcomeTitle, welcomeDescription, welcomeButtonStart):
                        self.strings.welcomeTitle = welcomeTitle
                        self.strings.welcomeDescription = welcomeDescription
                        self.strings.welcomeButtonStart = welcomeButtonStart
                    case let .provider(provider):
                        self.strings.welcomeTitle = provider.welcomeTitle
                        self.strings.welcomeDescription = provider.welcomeDescription
                        self.strings.welcomeButtonStart = provider.welcomeButtonStart
                }
                switch typography {
                    case .default:
                        break
                    case let .custom(welcomeTitle, welcomeDescription):
                        fonts.welcomeTitle = .init(welcomeTitle)
                        fonts.welcomeDescription = .init(welcomeDescription)
                    case let .provider(provider):
                        fonts.welcomeTitle = .init(provider.welcomeTitle)
                        fonts.welcomeDescription = .init(provider.welcomeDescription)
                }
        }
    }

    mutating func apply(onboarding: Aiuta.Configuration.Features.Onboarding) {
        switch onboarding {
            case .default:
                break
            case .none:
                features.onboarding.isEnabled = false
            case let .custom(howItWorks, bestResults, strings, shapes, data):
                apply(onboardingHowItWorks: howItWorks)
                apply(onboardingBestResults: bestResults)

                switch strings {
                    case .default:
                        break
                    case let .custom(next, start):
                        self.strings.onboardingButtonNext = next
                        self.strings.onboardingButtonStart = start
                    case let .provider(provider):
                        self.strings.onboardingButtonNext = provider.onboardingButtonNext
                        self.strings.onboardingButtonStart = provider.onboardingButtonStart
                }
                switch shapes {
                    case .inherited:
                        self.shapes.onboardingImageL = self.shapes.imageL
                        self.shapes.onboardingImageS = self.shapes.imageM
                    case let .custom(imageL, imageS):
                        self.shapes.onboardingImageL = imageL
                        self.shapes.onboardingImageS = imageS
                    case let .provider(provider):
                        self.shapes.onboardingImageL = provider.onboardingImageL
                        self.shapes.onboardingImageS = provider.onboardingImageS
                }
                switch data {
                    case .userDefaults:
                        break
                    case let .dataProvider(provider):
                        features.onboarding.dataProvider = provider
                }
        }
    }

    mutating func apply(onboardingHowItWorks: Aiuta.Configuration.Features.Onboarding.HowItWorks) {
        switch onboardingHowItWorks {
            case .default:
                break
            case let .custom(images, strings):
                switch images {
                    case .builtIn:
                        break
                    case let .custom(items):
                        self.images.onboardingHowItWorksItems = items.map { item in
                            (photo: item.itemPhoto, preview: item.itemPreview)
                        }
                    case let .provider(provider):
                        self.images.onboardingHowItWorksItems = provider.onboardingHowItWorksItems.map { item in
                            (photo: item.itemPhoto, preview: item.itemPreview)
                        }
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(pageTitle, title, description):
                        self.strings.onboardingHowItWorksPageTitle = pageTitle
                        self.strings.onboardingHowItWorksTitle = title
                        self.strings.onboardingHowItWorksDescription = description
                    case let .provider(provider):
                        self.strings.onboardingHowItWorksPageTitle = provider.onboardingHowItWorksPageTitle
                        self.strings.onboardingHowItWorksTitle = provider.onboardingHowItWorksTitle
                        self.strings.onboardingHowItWorksDescription = provider.onboardingHowItWorksDescription
                }
        }
    }

    mutating func apply(onboardingBestResults: Aiuta.Configuration.Features.Onboarding.BestResults) {
        switch onboardingBestResults {
            case .none:
                features.onboarding.hasBestResults = false
            case let .custom(images, icons, strings, toggles):
                features.onboarding.hasBestResults = true
                switch images {
                    case let .custom(good, bad):
                        self.images.onboardingBestResultsGood = good
                        self.images.onboardingBestResultsBad = bad
                    case let .provider(provider):
                        self.images.onboardingBestResultsGood = provider.onboardingBestResultsGood
                        self.images.onboardingBestResultsBad = provider.onboardingBestResultsBad
                }
                switch icons {
                    case let .custom(good, bad):
                        self.icons.onboardingBestResultsGood24 = good
                        self.icons.onboardingBestResultsBad24 = bad
                    case let .provider(provider):
                        self.icons.onboardingBestResultsGood24 = provider.onboardingBestResultsGood24
                        self.icons.onboardingBestResultsBad24 = provider.onboardingBestResultsBad24
                }
                switch strings {
                    case let .custom(pageTitle, title, description):
                        self.strings.onboardingBestResultsPageTitle = pageTitle
                        self.strings.onboardingBestResultsTitle = title
                        self.strings.onboardingBestResultsDescription = description
                    case let .provider(provider):
                        self.strings.onboardingBestResultsPageTitle = provider.onboardingBestResultsPageTitle
                        self.strings.onboardingBestResultsTitle = provider.onboardingBestResultsTitle
                        self.strings.onboardingBestResultsDescription = provider.onboardingBestResultsDescription
                }
                switch toggles {
                    case .default:
                        break
                    case let .custom(reduceShadows):
                        styles.reduceOnboardingShadows = reduceShadows
                }
        }
    }

    mutating func apply(consent: Aiuta.Configuration.Features.Consent) {
        switch consent {
            case .none:
                features.consent.isEmbedded = false
            case let .embeddedIntoOnboarding(strings):
                switch strings {
                    case let .default(termsOfServiceUrl):
                        self.strings.setConsentLink(termsOfServiceUrl)
                    case let .custom(consentHtml):
                        self.strings.consentHtml = consentHtml
                    case let .provider(provider):
                        self.strings.consentHtml = provider.consentHtml
                }
            case let .standaloneOnboardingPage(strings, icons, styles, consentProvider):
                features.consent.isEmbedded = false
                features.consent.isOnboarding = true
                switch strings {
                    case let .custom(consentPageTitle, consentTitle, consentDescriptionHtml,
                                     consentFooterHtml, consentButtonAccept, consentButtonReject):
                        self.strings.consentPageTitle = consentPageTitle
                        self.strings.consentTitle = consentTitle
                        self.strings.consentDescriptionHtml = consentDescriptionHtml
                        self.strings.consentFooterHtml = consentFooterHtml
                        self.strings.consentButtonAccept = consentButtonAccept
                        self.strings.consentButtonReject = consentButtonReject
                    case let .provider(provider):
                        self.strings.consentPageTitle = provider.consentPageTitle
                        self.strings.consentTitle = provider.consentTitle
                        self.strings.consentDescriptionHtml = provider.consentDescriptionHtml
                        self.strings.consentFooterHtml = provider.consentFooterHtml
                        self.strings.consentButtonAccept = provider.consentButtonAccept
                        self.strings.consentButtonReject = provider.consentButtonReject
                }
                switch icons {
                    case .default:
                        break
                    case let .custom(consentTitle24):
                        self.icons.consentTitle24 = consentTitle24
                    case let .provider(provider):
                        self.icons.consentTitle24 = provider.consentTitle24
                }
                switch styles {
                    case .default:
                        break
                    case let .custom(drawBordersAroundConsents):
                        self.styles.drawBordersAroundConsents = drawBordersAroundConsents
                }
                switch consentProvider {
                    case let .userDefaults(consents):
                        features.consent.consents = consents
                    case let .userDefaultsWithCallback(consents, onObtain):
                        features.consent.consents = consents
                        features.consent.onObtain = onObtain
                    case let .dataProvider(consents, provider):
                        features.consent.consents = consents
                        features.consent.dataProvider = provider
                }
            case let .standaloneImagePickerPage(strings, icons, styles, consentProvider):
                features.consent.isEmbedded = false
                features.consent.isUploadButton = true
                switch strings {
                    case let .custom(consentPageTitle, consentTitle, consentDescriptionHtml,
                                     consentFooterHtml, consentButtonAccept, consentButtonReject):
                        self.strings.consentPageTitle = consentPageTitle
                        self.strings.consentTitle = consentTitle
                        self.strings.consentDescriptionHtml = consentDescriptionHtml
                        self.strings.consentFooterHtml = consentFooterHtml
                        self.strings.consentButtonAccept = consentButtonAccept
                        self.strings.consentButtonReject = consentButtonReject
                    case let .provider(provider):
                        self.strings.consentPageTitle = provider.consentPageTitle
                        self.strings.consentTitle = provider.consentTitle
                        self.strings.consentDescriptionHtml = provider.consentDescriptionHtml
                        self.strings.consentFooterHtml = provider.consentFooterHtml
                        self.strings.consentButtonAccept = provider.consentButtonAccept
                        self.strings.consentButtonReject = provider.consentButtonReject
                }
                switch icons {
                    case .default:
                        break
                    case let .custom(consentTitle24):
                        self.icons.consentTitle24 = consentTitle24
                    case let .provider(provider):
                        self.icons.consentTitle24 = provider.consentTitle24
                }
                switch styles {
                    case .default:
                        break
                    case let .custom(drawBordersAroundConsents):
                        self.styles.drawBordersAroundConsents = drawBordersAroundConsents
                }
                switch consentProvider {
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
        switch imagePicker {
            case .default:
                break
            case let .custom(camera, gallery, predefinedModel, uploadsHistory, images, strings):
                apply(camera: camera)
                apply(gallery: gallery)
                apply(predefinedModel: predefinedModel)
                apply(uploadsHistory: uploadsHistory)

                switch images {
                    case .builtIn:
                        break
                    case let .custom(imagePickerExamples):
                        self.images.imagePickerExamples = imagePickerExamples
                    case let .provider(provider):
                        self.images.imagePickerExamples = provider.imagePickerExamples
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(imagePickerTitle, imagePickerDescription, imagePickerButtonUploadPhoto):
                        self.strings.imagePickerTitle = imagePickerTitle
                        self.strings.imagePickerDescription = imagePickerDescription
                        self.strings.imagePickerButtonUploadPhoto = imagePickerButtonUploadPhoto
                    case let .provider(provider):
                        self.strings.imagePickerTitle = provider.imagePickerTitle
                        self.strings.imagePickerDescription = provider.imagePickerDescription
                        self.strings.imagePickerButtonUploadPhoto = provider.imagePickerButtonUploadPhoto
                }
        }
    }

    mutating func apply(camera: Aiuta.Configuration.Features.ImagePicker.Camera) {
        switch camera {
            case .default:
                break
            case .none:
                features.imagePicker.hasCamera = false
            case let .custom(icons, strings):
                features.imagePicker.hasCamera = true
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(camera24):
                        self.icons.camera24 = camera24
                    case let .provider(provider):
                        self.icons.camera24 = provider.camera24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(cameraButtonTakePhoto, cameraPermissionTitle,
                                     cameraPermissionDescription, cameraPermissionButtonOpenSettings):
                        self.strings.cameraButtonTakePhoto = cameraButtonTakePhoto
                        self.strings.cameraPermissionTitle = cameraPermissionTitle
                        self.strings.cameraPermissionDescription = cameraPermissionDescription
                        self.strings.cameraPermissionButtonOpenSettings = cameraPermissionButtonOpenSettings
                    case let .provider(provider):
                        self.strings.cameraButtonTakePhoto = provider.cameraButtonTakePhoto
                        self.strings.cameraPermissionTitle = provider.cameraPermissionTitle
                        self.strings.cameraPermissionDescription = provider.cameraPermissionDescription
                        self.strings.cameraPermissionButtonOpenSettings = provider.cameraPermissionButtonOpenSettings
                }
        }
    }

    mutating func apply(gallery: Aiuta.Configuration.Features.ImagePicker.Gallery) {
        switch gallery {
            case .default:
                break
            case let .custom(icons, strings):
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(gallery24):
                        self.icons.gallery24 = gallery24
                    case let .provider(provider):
                        self.icons.gallery24 = provider.gallery24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(galleryButtonSelectPhoto):
                        self.strings.galleryButtonSelectPhoto = galleryButtonSelectPhoto
                    case let .provider(provider):
                        self.strings.galleryButtonSelectPhoto = provider.galleryButtonSelectPhoto
                }
        }
    }

    mutating func apply(predefinedModel: Aiuta.Configuration.Features.ImagePicker.PredefinedModels) {
        switch predefinedModel {
            case .default:
                features.imagePicker.hasPredefinedModels = true
            case .none:
                features.imagePicker.hasPredefinedModels = false
            case let .custom(data, icons, strings):
                features.imagePicker.hasPredefinedModels = true
                switch data {
                    case .default:
                        break
                    case let .custom(preferredCategoryId):
                        features.imagePicker.preferredPredefinedModelsCategoryId = preferredCategoryId
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(selectModels24):
                        self.icons.selectModels24 = selectModels24
                    case let .provider(provider):
                        self.icons.selectModels24 = provider.selectModels24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(predefinedModelsTitle, predefinedModelsOr,
                                     predefinedModelsEmptyListError, predefinedModelsCategories):
                        self.strings.predefinedModelsTitle = predefinedModelsTitle
                        self.strings.predefinedModelsOr = predefinedModelsOr
                        self.strings.predefinedModelsEmptyListError = predefinedModelsEmptyListError
                        self.strings.predefinedModelsCategories = predefinedModelsCategories
                    case let .provider(provider):
                        self.strings.predefinedModelsTitle = provider.predefinedModelsTitle
                        self.strings.predefinedModelsOr = provider.predefinedModelsOr
                        self.strings.predefinedModelsEmptyListError = provider.predefinedModelsEmptyListError
                        self.strings.predefinedModelsCategories = provider.predefinedModelsCategories
                }
        }
    }

    mutating func apply(uploadsHistory: Aiuta.Configuration.Features.ImagePicker.UploadsHistory) {
        switch uploadsHistory {
            case .default:
                features.imagePicker.hasUploadsHistory = true
            case .none:
                features.imagePicker.hasUploadsHistory = false
            case let .custom(strings, styles, history):
                features.imagePicker.hasUploadsHistory = true
                switch strings {
                    case .default:
                        break
                    case let .custom(uploadsHistoryButtonNewPhoto, uploadsHistoryTitle,
                                     uploadsHistoryButtonChangePhoto):
                        self.strings.uploadsHistoryButtonNewPhoto = uploadsHistoryButtonNewPhoto
                        self.strings.uploadsHistoryTitle = uploadsHistoryTitle
                        self.strings.uploadsHistoryButtonChangePhoto = uploadsHistoryButtonChangePhoto
                    case let .provider(provider):
                        self.strings.uploadsHistoryButtonNewPhoto = provider.uploadsHistoryButtonNewPhoto
                        self.strings.uploadsHistoryTitle = provider.uploadsHistoryTitle
                        self.strings.uploadsHistoryButtonChangePhoto = provider.uploadsHistoryButtonChangePhoto
                }
                switch styles {
                    case .default:
                        break
                    case let .custom(changePhotoButtonStyle):
                        self.styles.changePhotoButtonStyle = changePhotoButtonStyle
                }
                switch history {
                    case .userDefaults:
                        break
                    case let .dataProvider(provider):
                        features.imagePicker.historyProvider = provider
                }
        }
    }

    mutating func apply(tryOn: Aiuta.Configuration.Features.TryOn) {
        switch tryOn {
            case .default:
                break
            case let .custom(loadingPage, inputImageValidation, cart, fitDisclaimer, feedback,
                             generationsHistory, otherPhoto, icons, styles, strings, toggles):
                apply(loadingPage: loadingPage)
                apply(inputImageValidation: inputImageValidation)
                apply(cart: cart)
                apply(fitDisclaimer: fitDisclaimer)
                apply(feedback: feedback)
                apply(generationsHistory: generationsHistory)
                apply(otherPhoto: otherPhoto)

                switch icons {
                    case .builtIn:
                        break
                    case let .custom(magic20):
                        self.icons.magic20 = magic20
                    case let .provider(provider):
                        self.icons.magic20 = provider.magic20
                }
                switch styles {
                    case .default:
                        break
                    case let .custom(tryOnButtonGradient):
                        colors.tryOnButtonGradient = tryOnButtonGradient
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(tryOnPageTitle, tryOn):
                        self.strings.tryOnPageTitle = tryOnPageTitle
                        self.strings.tryOn = tryOn
                    case let .provider(provider):
                        self.strings.tryOnPageTitle = provider.tryOnPageTitle
                        self.strings.tryOn = provider.tryOn
                }
                switch toggles {
                    case .default:
                        break
                    case let .custom(allowsBackgroundExecution, tryGeneratePersonSegmentation):
                        features.tryOn.allowsBackgroundExecution = allowsBackgroundExecution
                        features.tryOn.tryGeneratePersonSegmentation = tryGeneratePersonSegmentation
                }
        }
    }

    mutating func apply(loadingPage: Aiuta.Configuration.Features.TryOn.LoadingPage) {
        switch loadingPage {
            case .default:
                break
            case let .custom(strings, styles):
                switch strings {
                    case .default:
                        break
                    case let .custom(tryOnLoadingStatusUploadingImage, tryOnLoadingStatusScanningBody,
                                     tryOnLoadingStatusGeneratingOutfit):
                        self.strings.tryOnLoadingStatusUploadingImage = tryOnLoadingStatusUploadingImage
                        self.strings.tryOnLoadingStatusScanningBody = tryOnLoadingStatusScanningBody
                        self.strings.tryOnLoadingStatusGeneratingOutfit = tryOnLoadingStatusGeneratingOutfit
                    case let .provider(provider):
                        self.strings.tryOnLoadingStatusUploadingImage = provider.tryOnLoadingStatusUploadingImage
                        self.strings.tryOnLoadingStatusScanningBody = provider.tryOnLoadingStatusScanningBody
                        self.strings.tryOnLoadingStatusGeneratingOutfit = provider.tryOnLoadingStatusGeneratingOutfit
                }
                switch styles {
                    case .default:
                        break
                    case let .custom(backgroundGradient, statusStyle):
                        colors.tryOnBackgroundGradient = backgroundGradient
                        self.styles.loadingStatusStyle = statusStyle
                }
        }
    }

    mutating func apply(inputImageValidation: Aiuta.Configuration.Features.TryOn.InputValidation) {
        switch inputImageValidation {
            case .default:
                break
            case let .custom(strings):
                switch strings {
                    case .default:
                        break
                    case let .custom(invalidInputImageDescription, invalidInputImageChangePhotoButton):
                        self.strings.invalidInputImageDescription = invalidInputImageDescription
                        self.strings.invalidInputImageChangePhotoButton = invalidInputImageChangePhotoButton
                    case let .provider(provider):
                        self.strings.invalidInputImageDescription = provider.invalidInputImageDescription
                        self.strings.invalidInputImageChangePhotoButton = provider.invalidInputImageChangePhotoButton
                }
        }
    }

    mutating func apply(cart: Aiuta.Configuration.Features.TryOn.Cart) {
        switch cart {
            case let .default(handler):
                features.tryOn.cartHandler = handler
            case let .custom(strings, handler):
                features.tryOn.cartHandler = handler
                switch strings {
                    case .default:
                        break
                    case let .custom(addToCart):
                        self.strings.addToCart = addToCart
                    case let .provider(provider):
                        self.strings.addToCart = provider.addToCart
                }
        }
    }

    mutating func apply(fitDisclaimer: Aiuta.Configuration.Features.TryOn.FitDisclaimer) {
        switch fitDisclaimer {
            case .default:
                break
            case .none:
                features.tryOn.showsFitDisclaimerOnResults = false
            case let .custom(strings, typography, icons):
                switch strings {
                    case .default:
                        break
                    case let .custom(fitDisclaimerTitle, fitDisclaimerDescription, fitDisclaimerCloseButton):
                        self.strings.fitDisclaimerTitle = fitDisclaimerTitle
                        self.strings.fitDisclaimerDescription = fitDisclaimerDescription
                        self.strings.fitDisclaimerCloseButton = fitDisclaimerCloseButton
                    case let .provider(provider):
                        self.strings.fitDisclaimerTitle = provider.fitDisclaimerTitle
                        self.strings.fitDisclaimerDescription = provider.fitDisclaimerDescription
                        self.strings.fitDisclaimerCloseButton = provider.fitDisclaimerCloseButton
                }
                switch typography {
                    case .default:
                        break
                    case let .custom(disclaimer: disclaimer):
                        fonts.disclaimer = .init(disclaimer)
                    case let .provider(provider):
                        fonts.disclaimer = .init(provider.disclaimer)
                }
                switch icons {
                    case .none:
                        break
                    case let .custom(info20):
                        self.icons.info20 = info20
                    case let .provider(provider):
                        self.icons.info20 = provider.info20
                }
        }
    }

    mutating func apply(feedback: Aiuta.Configuration.Features.TryOn.Feedback) {
        switch feedback {
            case .default:
                break
            case .none:
                features.tryOn.askForUserFeedbackOnResults = false
            case let .custom(other, strings, icons, shapes):
                switch strings {
                    case .default:
                        break
                    case let .custom(feedbackTitle, feedbackOptions, feedbackButtonSkip,
                                     feedbackButtonSend, feedbackGratitudeText):
                        self.strings.feedbackTitle = feedbackTitle
                        self.strings.feedbackOptions = feedbackOptions
                        self.strings.feedbackButtonSkip = feedbackButtonSkip
                        self.strings.feedbackButtonSend = feedbackButtonSend
                        self.strings.feedbackGratitudeText = feedbackGratitudeText
                    case let .provider(provider):
                        self.strings.feedbackTitle = provider.feedbackTitle
                        self.strings.feedbackOptions = provider.feedbackOptions
                        self.strings.feedbackButtonSkip = provider.feedbackButtonSkip
                        self.strings.feedbackButtonSend = provider.feedbackButtonSend
                        self.strings.feedbackGratitudeText = provider.feedbackGratitudeText
                }
                switch icons {
                    case .default:
                        break
                    case let .custom(like36, dislike36, gratitude40):
                        self.icons.like36 = like36
                        self.icons.dislike36 = dislike36
                        self.icons.gratitude40 = gratitude40
                    case let .provider(provider):
                        self.icons.like36 = provider.like36
                        self.icons.dislike36 = provider.dislike36
                        self.icons.gratitude40 = provider.gratitude40
                }
                switch shapes {
                    case .default:
                        break
                    case .inherited:
                        self.shapes.feedbackButton = self.shapes.buttonS
                    case let .custom(feedbackButton: feedbackButton):
                        self.shapes.feedbackButton = feedbackButton
                    case let .provider(provider):
                        self.shapes.feedbackButton = provider.feedbackButton
                }
                switch other {
                    case .default:
                        break
                    case .none:
                        features.tryOn.askForOtherFeedbackOnResults = false
                    case let .custom(strings):
                        switch strings {
                            case .default:
                                break
                            case let .custom(feedbackOptionOther, otherFeedbackTitle,
                                             otherFeedbackButtonSend, otherFeedbackButtonCancel):
                                self.strings.feedbackOptionOther = feedbackOptionOther
                                self.strings.otherFeedbackTitle = otherFeedbackTitle
                                self.strings.otherFeedbackButtonSend = otherFeedbackButtonSend
                                self.strings.otherFeedbackButtonCancel = otherFeedbackButtonCancel
                            case let .provider(provider):
                                self.strings.feedbackOptionOther = provider.feedbackOptionOther
                                self.strings.otherFeedbackTitle = provider.otherFeedbackTitle
                                self.strings.otherFeedbackButtonSend = provider.otherFeedbackButtonSend
                                self.strings.otherFeedbackButtonCancel = provider.otherFeedbackButtonCancel
                        }
                }
        }
    }

    mutating func apply(generationsHistory: Aiuta.Configuration.Features.TryOn.GenerationsHistory) {
        switch generationsHistory {
            case .default:
                break
            case .none:
                features.tryOn.hasGenerationsHistory = false
            case let .custom(icons, strings, history):
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(history24):
                        self.icons.history24 = history24
                    case let .provider(provider):
                        self.icons.history24 = provider.history24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(generationsHistoryPageTitle):
                        self.strings.generationsHistoryPageTitle = generationsHistoryPageTitle
                    case let .provider(provider):
                        self.strings.generationsHistoryPageTitle = provider.generationsHistoryPageTitle
                }
                switch history {
                    case .userDefaults:
                        break
                    case let .dataProvider(provider):
                        features.tryOn.historyProvider = provider
                }
        }
    }

    mutating func apply(otherPhoto: Aiuta.Configuration.Features.TryOn.ContinueWithOtherPhoto) {
        switch otherPhoto {
            case .default:
                break
            case let .custom(icon):
                switch icon {
                    case .builtIn:
                        break
                    case let .custom(changePhoto24):
                        icons.changePhoto24 = changePhoto24
                    case let .provider(provider):
                        icons.changePhoto24 = provider.changePhoto24
                }
        }
    }

    mutating func apply(share: Aiuta.Configuration.Features.Share) {
        switch share {
            case .default:
                break
            case .none:
                features.share.isEnabled = false
            case let .custom(watermark, text, icons, strings):
                switch watermark {
                    case .none:
                        break
                    case let .custom(shareWatermark):
                        images.shareWatermark = shareWatermark
                    case let .provider(provider):
                        images.shareWatermark = provider.shareWatermark
                }
                switch text {
                    case .none:
                        break
                    case let .dataProvider(provider):
                        features.share.additionalTextProvider = provider
                }
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(share24):
                        self.icons.share24 = share24
                    case let .provider(provider):
                        self.icons.share24 = provider.share24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(shareButton):
                        self.strings.shareButton = shareButton
                    case let .provider(provider):
                        self.strings.shareButton = provider.shareButton
                }
        }
    }

    mutating func apply(wishlist: Aiuta.Configuration.Features.Wishlist) {
        switch wishlist {
            case .none:
                features.wishlist.isEnabled = false
            case let .custom(icons, strings, dataProvider):
                features.wishlist.dataProvider = dataProvider
                switch icons {
                    case .builtIn:
                        break
                    case let .custom(wishlist24, wishlistFill24):
                        self.icons.wishlist24 = wishlist24
                        self.icons.wishlistFill24 = wishlistFill24
                    case let .provider(provider):
                        self.icons.wishlist24 = provider.wishlist24
                        self.icons.wishlistFill24 = provider.wishlistFill24
                }
                switch strings {
                    case .default:
                        break
                    case let .custom(wishlistButtonAdd):
                        self.strings.wishlistButtonAdd = wishlistButtonAdd
                    case let .provider(provider):
                        self.strings.wishlistButtonAdd = provider.wishlistButtonAdd
                }
        }
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
        switch debugSettings {
            case .debug:
                settings.isLoggingEnabled = true
                settings.infoPlistDescriptionsPolicy = .fatal
                settings.emptyStringsPolicy = .fatal
                settings.listSizePolicy = .fatal
            case .release:
                settings.isLoggingEnabled = false
                settings.infoPlistDescriptionsPolicy = .ignore
                settings.emptyStringsPolicy = .ignore
                settings.listSizePolicy = .ignore
            case let .preset(isLoggingEnabled, allValidationPolicies):
                settings.isLoggingEnabled = isLoggingEnabled
                settings.infoPlistDescriptionsPolicy = allValidationPolicies
                settings.emptyStringsPolicy = allValidationPolicies
                settings.listSizePolicy = allValidationPolicies
            case let .custom(isLoggingEnabled, infoPlistDescriptionsPolicy, emptyStringsPolicy, listSizePolicy):
                settings.isLoggingEnabled = isLoggingEnabled
                settings.infoPlistDescriptionsPolicy = infoPlistDescriptionsPolicy
                settings.emptyStringsPolicy = emptyStringsPolicy
                settings.listSizePolicy = listSizePolicy
        }
    }
}
