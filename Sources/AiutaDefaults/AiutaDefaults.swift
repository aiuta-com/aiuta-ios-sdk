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

import AiutaConfig
import AiutaCore
import UIKit

extension Aiuta.Configuration {
    public static func `default`(
        auth: Aiuta.Auth,
        cartHandler: Aiuta.Configuration.Features.TryOn.Cart.Handler,
        analytics: Aiuta.Analytics? = nil,
        debugSettings: DebugSettings = .release,
        localization: LocalizationPack = .init(),
        colors: ColorsPack = .init(),
        icons: IconsPack,
        images: ImagesPack,
        typography: TypographyPack = .init(),
        shapes: ShapesPack = .init()
    ) -> Self {
        .init(
            auth: auth,
            userInterface: .init(
                theme: .init(
                    color: .init(
                        scheme: .light,
                        brand: colors.brand,
                        primary: colors.primary,
                        secondary: colors.secondary,
                        onDark: colors.onDark,
                        onLight: colors.onLight,
                        background: colors.background,
                        screen: nil,
                        neutral: colors.neutral,
                        border: colors.border
                    ),
                    label: .init(
                        typography: .init(
                            titleL: typography.titleL,
                            titleM: typography.titleM,
                            regular: typography.regular,
                            subtle: typography.subtle,
                            footnote: typography.footnote
                        )
                    ),
                    image: .init(
                        shapes: .init(
                            imageL: shapes.imageL,
                            imageM: shapes.imageM,
                            imageS: shapes.imageS
                        ),
                        icons: .init(
                            imageError36: icons.imageError36
                        )
                    ),
                    button: .init(
                        typography: .init(
                            buttonM: typography.buttonM,
                            buttonS: typography.buttonS
                        ),
                        shapes: .init(
                            buttonL: shapes.buttonL,
                            buttonM: shapes.buttonM,
                            buttonS: shapes.buttonS
                        )
                    ),
                    pageBar: .init(
                        typography: .init(
                            pageTitle: typography.pageTitle
                        ),
                        icons: .init(
                            back24: icons.back24,
                            close24: icons.close24
                        ),
                        settings: .init(preferCloseButtonOnTheRight: false)
                    ),
                    bottomSheet: .init(
                        typography: .init(
                            iconButton: typography.iconButton
                        ),
                        shapes: .init(
                            bottomSheet: shapes.bottomSheet
                        ),
                        grabber: .init(width: 36, height: 3, offset: 6),
                        settings: .init(extendDelimitersToTheRight: false, extendDelimitersToTheLeft: false)
                    ),
                    activityIndicator: .init(
                        icons: .init(
                            loading14: icons.loading14
                        ),
                        colors: .init(
                            overlay: colors.overlay
                        ),
                        settings: .init(indicationDelay: 500, spinDuration: 1500)
                    ),
                    selectionSnackbar: .init(
                        strings: .init(
                            select: localization.select,
                            cancel: localization.cancel,
                            selectAll: localization.selectAll,
                            unselectAll: localization.unselectAll
                        ),
                        icons: .init(
                            trash24: icons.trash24,
                            check20: icons.check20
                        ),
                        colors: .init(
                            selectionBackground: colors.selectionBackground
                        )
                    ),
                    errorSnackbar: .init(
                        strings: .init(
                            defaultErrorMessage: localization.defaultErrorMessage,
                            tryAgainButton: localization.tryAgainButton
                        ),
                        icons: .init(
                            error36: icons.error36
                        ),
                        colors: .init(
                            errorBackground: colors.errorBackground,
                            errorPrimary: colors.errorPrimary
                        )
                    ),
                    productBar: .init(
                        icons: .init(
                            arrow16: icons.arrow16
                        ),
                        typography: .init(
                            product: typography.product,
                            brand: typography.brand
                        ),
                        settings: .init(applyProductFirstImageExtraPadding: false),
                        prices: .init(
                            typography: .init(
                                price: typography.price
                            ),
                            colors: .init(
                                discountedPrice: colors.discountedPrice
                            )
                        )
                    ),
                    powerBar: .init(
                        strings: .init(poweredByAiuta: localization.poweredByAiuta),
                        colors: .init(aiuta: .default)
                    )
                ),
                presentationStyle: .pageSheet,
                swipeToDismissPolicy: .protectTheNecessaryPages
            ),
            features: .init(
                welcomeScreen: nil,
                onboarding: .init(
                    howItWorks: .init(
                        images: .init(
                            onboardingHowItWorksItems: images.onboardingHowItWorksItems
                        ),
                        strings: .init(
                            onboardingHowItWorksPageTitle: nil,
                            onboardingHowItWorksTitle: localization.onboardingHowItWorksTitle,
                            onboardingHowItWorksDescription: localization.onboardingHowItWorksDescription
                        )
                    ),
                    bestResults: nil,
                    strings: .init(
                        onboardingButtonNext: localization.onboardingButtonNext,
                        onboardingButtonStart: localization.onboardingButtonStart
                    ),
                    shapes: .init(
                        onboardingImageL: shapes.onboardingImageL,
                        onboardingImageS: shapes.onboardingImageS
                    ),
                    data: .userDefaults
                ),
                consent: .embeddedIntoOnboarding(.init(
                    strings: .init(
                        consentHtml: localization.consentHtml
                    )
                )),
                imagePicker: .init(
                    camera: .init(
                        icons: .init(
                            camera24: icons.camera24
                        ),
                        strings: .init(
                            cameraButtonTakePhoto: localization.cameraButtonTakePhoto,
                            cameraPermissionTitle: localization.cameraPermissionTitle,
                            cameraPermissionDescription: localization.cameraPermissionDescription,
                            cameraPermissionButtonOpenSettings: localization.cameraPermissionButtonOpenSettings
                        )
                    ),
                    photoGallery: .init(
                        icons: .init(
                            gallery24: icons.gallery24
                        ),
                        strings: .init(
                            galleryButtonSelectPhoto: localization.galleryButtonSelectPhoto
                        )
                    ),
                    predefinedModels: .init(
                        data: .init(preferredCategoryId: nil),
                        icons: .init(
                            selectModels24: icons.selectModels24
                        ),
                        strings: .init(
                            predefinedModelsTitle: localization.predefinedModelsTitle,
                            predefinedModelsOr: localization.predefinedModelsOr,
                            predefinedModelsEmptyListError: localization.predefinedModelsEmptyListError,
                            predefinedModelsCategories: localization.predefinedModelsCategories
                        )
                    ),
                    protectionDisclaimer: nil,
                    uploadsHistory: .init(
                        strings: .init(
                            uploadsHistoryButtonNewPhoto: localization.uploadsHistoryButtonNewPhoto,
                            uploadsHistoryTitle: localization.uploadsHistoryTitle,
                            uploadsHistoryButtonChangePhoto: localization.uploadsHistoryButtonChangePhoto
                        ),
                        styles: .init(
                            changePhotoButtonStyle: .blurred(hasOutline: false)
                        ),
                        history: .userDefaults
                    ),
                    images: .init(
                        imagePickerExamples: images.imagePickerExamples
                    ),
                    strings: .init(
                        imagePickerTitle: localization.imagePickerTitle,
                        imagePickerDescription: localization.imagePickerDescription,
                        imagePickerButtonUploadPhoto: localization.imagePickerButtonUploadPhoto
                    )
                ),
                tryOn: .init(
                    loadingPage: .init(
                        strings: .init(
                            tryOnLoadingStatusUploadingImage: localization.tryOnLoadingStatusUploadingImage,
                            tryOnLoadingStatusScanningBody: localization.tryOnLoadingStatusScanningBody,
                            tryOnLoadingStatusGeneratingOutfit: localization.tryOnLoadingStatusGeneratingOutfit
                        ),
                        styles: .init(
                            backgroundGradient: colors.loadingGradient,
                            statusStyle: .blurred(hasOutline: false)
                        )
                    ),
                    inputImageValidation: .init(
                        strings: .init(
                            invalidInputImageDescription: localization.invalidInputImageDescription,
                            invalidInputImageChangePhotoButton: localization.invalidInputImageChangePhotoButton
                        )
                    ),
                    cart: .init(
                        strings: .init(
                            addToCart: localization.addToCart
                        ),
                        handler: cartHandler,
                        outfit: nil
                    ),
                    fitDisclaimer: .init(
                        strings: .init(
                            fitDisclaimerTitle: localization.fitDisclaimerTitle,
                            fitDisclaimerDescription: localization.fitDisclaimerDescription,
                            fitDisclaimerCloseButton: localization.fitDisclaimerCloseButton
                        ),
                        icons: .init(info20: nil)
                    ),
                    feedback: .init(
                        other: .init(
                            strings: .init(
                                feedbackOptionOther: localization.feedbackOptionOther,
                                otherFeedbackTitle: localization.otherFeedbackTitle,
                                otherFeedbackButtonSend: localization.otherFeedbackButtonSend,
                                otherFeedbackButtonCancel: localization.otherFeedbackButtonCancel
                            )
                        ),
                        strings: .init(
                            feedbackTitle: localization.feedbackTitle,
                            feedbackOptions: localization.feedbackOptions,
                            feedbackButtonSkip: localization.feedbackButtonSkip,
                            feedbackButtonSend: localization.feedbackButtonSend,
                            feedbackGratitudeText: localization.feedbackGratitudeText
                        ),
                        icons: .init(
                            like36: icons.like36,
                            dislike36: icons.dislike36,
                            gratitude40: UIImage()
                        ),
                        shapes: .init(
                            feedbackButton: shapes.feedbackButton
                        )
                    ),
                    generationsHistory: .init(
                        icons: .init(
                            history24: icons.history24
                        ),
                        strings: .init(
                            generationsHistoryPageTitle: localization.generationsHistoryPageTitle
                        ),
                        history: .userDefaults
                    ),
                    otherPhoto: .init(
                        icon: .init(
                            changePhoto24: icons.changePhoto24
                        )
                    ),
                    icons: .init(
                        magic20: icons.magic20
                    ),
                    styles: .init(tryOnButtonGradient: []),
                    strings: .init(
                        tryOnPageTitle: localization.tryOnPageTitle,
                        tryOn: localization.tryOn
                    ),
                    toggles: .init(
                        allowsBackgroundExecution: true,
                        tryGeneratePersonSegmentation: true
                    )
                ),
                share: .init(
                    watermark: nil,
                    dataProvider: nil,
                    icons: .init(
                        share24: icons.share24
                    ),
                    strings: .init(
                        shareButton: localization.shareButton
                    )
                ),
                wishlist: nil,
                sizeFit: nil
            ),
            analytics: analytics,
            debugSettings: debugSettings
        )
    }
}
