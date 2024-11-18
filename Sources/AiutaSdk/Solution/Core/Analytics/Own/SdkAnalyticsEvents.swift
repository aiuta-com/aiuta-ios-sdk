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

@_spi(Aiuta) import AiutaKit
import Foundation

extension AnalyticEvent {
    static func session(_ event: AnalyticEvent.Session) -> AnalyticEvent { event.event }
    static func onBoarding(_ event: AnalyticEvent.OnBoarding) -> AnalyticEvent { event.event }
    static func mainScreen(_ event: AnalyticEvent.MainScreen) -> AnalyticEvent { event.event }
    static func tryOn(_ event: AnalyticEvent.TryOn) -> AnalyticEvent { event.event }
    static func results(_ event: AnalyticEvent.ResultsScreen) -> AnalyticEvent { event.event }
    static func history(_ event: AnalyticEvent.History) -> AnalyticEvent { event.event }
    static func share(_ event: AnalyticEvent.Share) -> AnalyticEvent { event.event }
    static func feedback(_ event: AnalyticEvent.Feedback) -> AnalyticEvent { event.event }
}

extension AnalyticEvent {
    enum Session {
        enum Action: String {
            case none, addToCart, addToWishlist, showSkuInfo
        }

        enum Origin: String {
            case skuPopup, resultsScreen, moreToTry, mainScreen
        }

        case configure(hasCustomConfiguration: Bool, configuration: Aiuta.Configuration)
        case start(sku: Aiuta.Product, relatedCount: Int)
        case finish(action: Action, origin: Origin, sku: Aiuta.Product?)

        var event: AnalyticEvent {
            switch self {
                case let .configure(hasCustomConfiguration, configuration):
                    return AnalyticEvent("Configure", [
                        "has_custom_configuration": hasCustomConfiguration,
                        "is_watermark_provided": configuration.behavior.watermark.image.isSome,
                        "is_history_enable": configuration.behavior.isTryonHistoryAvailable,
                    ], level: .significant)

                case let .start(sku, relatedCount):
                    return AnalyticEvent("StartSession", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "related_sku_count": relatedCount,
                        "price": sku.localizedOldPrice.isSome ? sku.localizedOldPrice! : sku.localizedPrice,
                        "price_discounted": sku.localizedOldPrice.isSome ? sku.localizedPrice : nil,
                        "store": sku.localizedBrand,
                        "additional_share_info": sku.additionalShareInfo,
                    ], level: .significant)

                case let .finish(action, origin, sku):
                    return AnalyticEvent("FinishSession", [
                        "action": action.rawValue.firstCapitalized,
                        "origin": origin.rawValue.firstCapitalized,
                        "sku_id": sku?.skuId,
                        "sku_catalog_name": sku?.skuCatalog,
                    ], level: .significant)
            }
        }
    }

    enum OnBoarding {
        case start
        case next(index: Int)
        case finish

        var event: AnalyticEvent {
            switch self {
                case .start:
                    return AnalyticEvent("StartOnBoarding")

                case let .next(index: index):
                    return AnalyticEvent("ContinueOnBoarding", [
                        "page": index + 1,
                    ])

                case .finish:
                    return AnalyticEvent("FinishOnBoarding")
            }
        }
    }

    enum MainScreen {
        case open(lastPhotosCount: Int)
        case changePhoto(hasCurrent: Bool, hasHistory: Bool)
        case selectOldPhotos(count: Int)
        case selectNewPhotos(camera: Int, gallery: Int)

        var event: AnalyticEvent {
            switch self {
                case let .open(lastPhotosCount: lastPhotosCount):
                    return AnalyticEvent("OpenMainScreen", [
                        "last_photos_selection": lastPhotosCount,
                    ])

                case let .changePhoto(hasCurrent: hasCurrent, hasHistory: hasHistory):
                    return AnalyticEvent("TapChangePhoto", [
                        "has_current_photos": hasCurrent,
                        "has_history_photos": hasHistory,
                    ])

                case let .selectOldPhotos(count: count):
                    return AnalyticEvent("SelectOldPhotos", [
                        "count": count,
                    ])

                case let .selectNewPhotos(camera: camera, gallery: gallery):
                    return AnalyticEvent("SelectNewPhotos", [
                        "from_camera": camera,
                        "from_gallery": gallery,
                    ])
            }
        }
    }

    enum TryOn {
        enum Origin: String {
            case tryOnButton, selectPhotos
        }

        enum Error: String {
            case skuUnknown, skuNotReady, uploadFailed, tryOnStartFailed, tryOnOperationFailed, tryOnOperationAborted
        }

        case start(origin: Origin, sku: Aiuta.Product?, photosCount: Int)
        case generate(sku: Aiuta.Product)
        case finish(sku: Aiuta.Product, time: TimeInterval)
        case error(sku: Aiuta.Product, type: Error)

        var event: AnalyticEvent {
            switch self {
                case let .start(origin, sku, photosCount):
                    return AnalyticEvent("StartUITryOn", [
                        "origin": origin.rawValue.firstCapitalized,
                        "sku_id": sku?.skuId,
                        "sku_catalog_name": sku?.skuCatalog,
                        "photos_count": photosCount,
                    ])

                case let .generate(sku):
                    return AnalyticEvent("StartTryOn", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                    ])

                case let .finish(sku, time):
                    return AnalyticEvent("FinishTryOn", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "generation_time": time.seconds,
                    ])

                case let .error(sku, type):
                    return AnalyticEvent("TryOnError", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "type": type.rawValue.firstCapitalized,
                    ])
            }
        }
    }

    enum ResultsScreen {
        enum NavigationType: String {
            case thumbnail, swipe
        }

        case open(sku: Aiuta.Product?)
        case view(sku: Aiuta.Product?, index: Int)
        case update(sku: Aiuta.Product, generatedCount: Int)
        case showRelated
        case tapRelated(sku: Aiuta.Product)
        case selectRelated(sku: Aiuta.Product)

        var event: AnalyticEvent {
            switch self {
                case let .open(sku):
                    return AnalyticEvent("OpenResultsScreen", [
                        "sku_id": sku?.skuId,
                        "sku_catalog_name": sku?.skuCatalog,
                    ])

                case let .view(sku, index):
                    return AnalyticEvent("ViewGeneratedImage", [
                        "sku_id": sku?.skuId,
                        "sku_catalog_name": sku?.skuCatalog,
                        "image_number": index + 1,
                    ])

                case let .update(sku, generatedCount):
                    return AnalyticEvent("UpdateResultsScreen", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "generated_photos": generatedCount,
                    ])

                case .showRelated:
                    return AnalyticEvent("ViewMoreToTryOn")

                case let .tapRelated(sku):
                    return AnalyticEvent("TapMoreToTryOn", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                    ])

                case let .selectRelated(sku):
                    return AnalyticEvent("SelectMoreToTryOn", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                    ])
            }
        }
    }

    enum History {
        case open

        var event: AnalyticEvent {
            switch self {
                case .open: return AnalyticEvent("OpenHistoryScreen")
            }
        }
    }

    enum Share {
        enum Origin: String {
            case resultsScreen, resultsFullScreen, history
        }

        case start(origin: Origin, count: Int, text: String?)
        case success(origin: Origin, count: Int, activity: String?, text: String?)
        case cancelled(origin: Origin, count: Int, activity: String?)
        case failed(origin: Origin, count: Int, activity: String?, error: Error?)

        var event: AnalyticEvent {
            switch self {
                case let .start(origin, count, text):
                    return AnalyticEvent("ShareGeneratedImage", [
                        "origin": origin.rawValue.firstCapitalized,
                        "count": count,
                        "additional_share_info": text,
                    ])

                case let .success(origin, count, activity, text):
                    return AnalyticEvent("ShareSuccessfully", [
                        "origin": origin.rawValue.firstCapitalized,
                        "count": count,
                        "target": activity,
                        "additional_share_info": text,
                    ])

                case let .cancelled(origin, count, activity):
                    return AnalyticEvent("ShareCanceled", [
                        "origin": origin.rawValue.firstCapitalized,
                        "count": count,
                        "target": activity,
                    ])

                case let .failed(origin, count, activity, error):
                    return AnalyticEvent("ShareFailed", [
                        "origin": origin.rawValue.firstCapitalized,
                        "count": count,
                        "target": activity,
                        "error": error?.localizedDescription,
                    ])
            }
        }
    }

    enum Feedback {
        case like(sku: Aiuta.Product)
        case dislike(sku: Aiuta.Product)
        case comment(sku: Aiuta.Product, text: String?)

        var event: AnalyticEvent {
            switch self {
                case let .like(sku):
                    return AnalyticEvent("LikeGenerationFeedback", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "generated_photo_position": 0,
                    ])
                case let .dislike(sku):
                    return AnalyticEvent("DislikeGenerationFeedback", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "generated_photo_position": 0,
                    ])
                case let .comment(sku, text):
                    return AnalyticEvent("GenerationFeedback", [
                        "sku_id": sku.skuId,
                        "sku_catalog_name": sku.skuCatalog,
                        "generated_photo_position": 0,
                        "feedback": text as Any,
                    ])
            }
        }
    }
}
