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

// MARK: - Features

extension Aiuta.Configuration.Features {
    public static var `default`: Self {
        .init(
            welcomeScreen: nil,
            onboarding: .default,
            consent: .embeddedIntoOnboarding(.init(
                strings: .init(
                    consentHtml: "Your photos will be processed by <b><a href=\"https://aiuta.com/legal/terms-of-service.html\">Terms of Use</a></b>"
                )
            )),
            imagePicker: .default,
            tryOn: .default,
            share: .default,
            wishlist: nil,
            sizeFit: nil
        )
    }
}

// MARK: - Onboarding

extension Aiuta.Configuration.Features.Onboarding {
    public static var `default`: Self {
        .init(
            howItWorks: .default,
            bestResults: nil,
            strings: .init(
                onboardingButtonNext: "Next",
                onboardingButtonStart: "Start"
            ),
            shapes: .init(
                onboardingImageL: .continuous(radius: 16),
                onboardingImageS: .continuous(radius: 16)
            ),
            data: .userDefaults
        )
    }
}

extension Aiuta.Configuration.Features.Onboarding.HowItWorks {
    public static var `default`: Self {
        .init(
            images: .init(
                onboardingHowItWorksItems: [
                    .init(
                        itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow1L")!,
                        itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow1S")!
                    ),
                    .init(
                        itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow2L")!,
                        itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow2S")!
                    ),
                    .init(
                        itemPhoto: AiutaAssets.bundleImage("aiutaImageBoardHow3L")!,
                        itemPreview: AiutaAssets.bundleImage("aiutaImageBoardHow3S")!
                    ),
                ]
            ),
            strings: .init(
                onboardingHowItWorksPageTitle: nil,
                onboardingHowItWorksTitle: "Try on before buying",
                onboardingHowItWorksDescription: "Upload a photo and see how items look on you"
            )
        )
    }
}

// MARK: - ImagePicker

extension Aiuta.Configuration.Features.ImagePicker {
    public static var `default`: Self {
        .init(
            camera: .default,
            photoGallery: .default,
            predefinedModels: .default,
            uploadsHistory: .default,
            images: .init(
                imagePickerExamples: [
                    AiutaAssets.bundleImage("aiutaImagePickerSample1"),
                    AiutaAssets.bundleImage("aiutaImagePickerSample2"),
                ].compactMap { $0 }
            ),
            strings: .init(
                imagePickerTitle: "Upload a photo of you",
                imagePickerDescription: "Select a photo where you are standing straight and clearly visible",
                imagePickerButtonUploadPhoto: "Upload a photo"
            )
        )
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Camera {
    public static var `default`: Self {
        .init(
            icons: .init(
                camera24: AiutaAssets.bundleImage("aiutaIcon24Camera")!
            ),
            strings: .init(
                cameraButtonTakePhoto: "Take a photo",
                cameraPermissionTitle: "Camera permission",
                cameraPermissionDescription: "Please allow access to the camera in the application settings",
                cameraPermissionButtonOpenSettings: "Settings"
            )
        )
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Gallery {
    public static var `default`: Self {
        .init(
            icons: .init(
                gallery24: AiutaAssets.bundleImage("aiutaIcon24Gallery")!
            ),
            strings: .init(
                galleryButtonSelectPhoto: "Choose from library"
            )
        )
    }
}

extension Aiuta.Configuration.Features.ImagePicker.PredefinedModels {
    public static var `default`: Self {
        .init(
            data: .init(preferredCategoryId: nil),
            icons: .init(
                selectModels24: AiutaAssets.bundleImage("aiutaIcon24Model")!
            ),
            strings: .init(
                predefinedModelsTitle: "Select your model",
                predefinedModelsOr: "Or",
                predefinedModelsEmptyListError: "The models list is empty",
                predefinedModelsCategories: ["man": "Men", "woman": "Women"]
            )
        )
    }
}

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    public static var `default`: Self {
        .init(
            strings: .init(
                uploadsHistoryButtonNewPhoto: "+ New photo or model",
                uploadsHistoryTitle: "Previously used",
                uploadsHistoryButtonChangePhoto: "Change photo"
            ),
            styles: .init(
                changePhotoButtonStyle: .blurred(hasOutline: false)
            ),
            history: .userDefaults
        )
    }
}

// MARK: - TryOn

extension Aiuta.Configuration.Features.TryOn {
    public static var `default`: Self {
        .init(
            loadingPage: .init(
                strings: .init(
                    tryOnLoadingStatusUploadingImage: "Uploading image",
                    tryOnLoadingStatusScanningBody: "Scanning the body",
                    tryOnLoadingStatusGeneratingOutfit: "Generating outfit"
                ),
                styles: .init(
                    backgroundGradient: [
                        UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 1),
                        UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 0.5),
                        UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 0),
                    ],
                    statusStyle: .blurred(hasOutline: false)
                )
            ),
            inputImageValidation: .init(
                strings: .init(
                    invalidInputImageDescription: "We couldn't detect\nanyone in this photo",
                    invalidInputImageChangePhotoButton: "Change photo"
                )
            ),
            cart: nil,
            fitDisclaimer: .init(
                strings: .init(
                    fitDisclaimerTitle: "Results may vary from real-life fit",
                    fitDisclaimerDescription: "Virtual try-on is a visualization tool that shows how items might look and may not perfectly represent how the item will fit in reality",
                    fitDisclaimerCloseButton: "Close"
                ),
                typography: .init(
                    disclaimer: .init(size: 12, weight: .regular, kern: -0.12)
                ),
                icons: .init(info20: nil)
            ),
            feedback: .init(
                other: .init(
                    strings: .init(
                        feedbackOptionOther: "Other",
                        otherFeedbackTitle: "Tell us what we could improve?",
                        otherFeedbackButtonSend: "Send feedback",
                        otherFeedbackButtonCancel: "Cancel"
                    )
                ),
                strings: .init(
                    feedbackTitle: "Can you tell us more?",
                    feedbackOptions: ["This style isn't for me", "The item looks off", "I look different"],
                    feedbackButtonSkip: "Skip",
                    feedbackButtonSend: "Send",
                    feedbackGratitudeText: "Thank you for your feedback"
                ),
                icons: .init(
                    like36: AiutaAssets.bundleImage("aiutaIcon36Like")!,
                    dislike36: AiutaAssets.bundleImage("aiutaIcon36Dislike")!,
                    gratitude40: UIImage()
                ),
                shapes: .init(
                    feedbackButton: .continuous(radius: .infinity)
                )
            ),
            generationsHistory: .init(
                icons: .init(
                    history24: AiutaAssets.bundleImage("aiutaIcon24History")!
                ),
                strings: .init(
                    generationsHistoryPageTitle: "History"
                ),
                history: .userDefaults
            ),
            otherPhoto: .init(
                icon: .init(
                    changePhoto24: AiutaAssets.bundleImage("aiutaIcon24CameraSwap")!
                )
            ),
            icons: .init(
                magic20: AiutaAssets.bundleImage("aiutaIcon20Magic")!
            ),
            styles: .init(tryOnButtonGradient: []),
            strings: .init(
                tryOnPageTitle: "Virtual Try-on",
                tryOn: "Try on"
            ),
            toggles: .init(
                allowsBackgroundExecution: true,
                tryGeneratePersonSegmentation: true
            )
        )
    }
}

// MARK: - Share

extension Aiuta.Configuration.Features.Share {
    public static var `default`: Self {
        .init(
            watermark: .none,
            text: .none,
            icons: .init(
                share24: AiutaAssets.bundleImage("aiutaIcon24Share")!
            ),
            strings: .init(
                shareButton: "Share"
            )
        )
    }
}
