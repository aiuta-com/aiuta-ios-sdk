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

extension AnalyticTracker {
    @available(iOS 13.0.0, *)
    func track(_ event: AnalyticEvent.Internal) {
        track(event.internalEvent())
    }
}

extension AnalyticEvent {
    @available(iOS 13.0.0, *)
    enum Internal {
        enum Flow: String {
            case tryOn, history
        }

        enum Origin: String {
            case selectedPhoto, tryOnButton, retakeButton, retryNotification, unknown
        }

        enum Result {
            case succeeded, canceled, failed(error: Error?)

            var rawValue: String {
                switch self {
                    case .succeeded: return "succeeded"
                    case .canceled: return "canceled"
                    case .failed: return "failed"
                }
            }

            var error: String? {
                switch self {
                    case .succeeded, .canceled:
                        return nil
                    case let .failed(error):
                        return error?.localizedDescription
                }
            }
        }

        enum ProcessError: String {
            case preparePhotoFailed,
                 uploadPhotoFailed,
                 noActiveSku,
                 requestOperationFailed,
                 startOperationFailed,
                 operationFailed,
                 operationAborted,
                 operationTimeout,
                 operationEmptyResults,
                 downloadResultFailed
        }

        case configure(configuration: Aiuta.Configuration, auth: Aiuta.AuthType, hasExternalDataProvider: Bool)
        case session(flow: Flow, product: Aiuta.Product?)
        case startTryOnProcess(origin: Origin, product: Aiuta.Product?)
        case error(error: Internal.ProcessError, product: Aiuta.Product?)
        case terminate(product: Aiuta.Product?)
        case success(stats: TryOnStats, total: TimeInterval, product: Aiuta.Product?)
        case share(result: Result, product: Aiuta.Product?, page: Aiuta.Event.Page, target: String?)
    }
}

@available(iOS 13.0.0, *)
extension AnalyticEvent.Internal {
    enum Key: String {
        case type, mode, authentication, pageId, productId,
             flow, origin, error, result, target,
             uploadDuration, tryOnDuration, downloadDuration, totalDuration,
             isHistoryAvailable,
             isWishlistAvailable,
             isPreOnboardingAvailable,
             isShareAvailable,
             isHostDataProviderEnabled
    }

    private enum Raw: String {
        case configure,
             session,
             startTryOnProcess,
             error,
             terminate,
             success,
             share
    }

    var rawValue: String {
        let raw: Raw
        switch self {
            case .configure: raw = .configure
            case .session: raw = .session
            case .startTryOnProcess: raw = .startTryOnProcess
            case .error: raw = .error
            case .terminate: raw = .terminate
            case .success: raw = .success
            case .share: raw = .share
        }
        return raw.rawValue
    }
}

@available(iOS 13.0.0, *)
extension AnalyticEvent.Internal {
    func name(withPrefix prefix: String = "", suffix: String = "Event", firstCapitalized: Bool = true) -> String {
        let isFirstCapitalized = !prefix.isEmpty || firstCapitalized
        let name = isFirstCapitalized ? rawValue.firstCapitalized : rawValue
        return "\(prefix)\(name)\(suffix)"
    }

    func parameters() -> [String: Any] {
        Dictionary(uniqueKeysWithValues: codingParameters().compactMap { k, v in
            guard let v else { return nil }
            return (k.rawValue, v)
        })
    }

    private func codingParameters() -> [Key: Any?] {
        switch self {
            case let .configure(configuration, auth, hasExternalDataProvider): return [
                    .authentication: auth.rawValue,
                    .mode: configuration.appearance.presentationStyle.rawValue,
                    .isHistoryAvailable: configuration.behavior.isTryonHistoryAvailable,
                    .isWishlistAvailable: configuration.behavior.isWishlistAvailable,
                    .isPreOnboardingAvailable: configuration.behavior.showSplashScreenBeforeOnboadring,
                    .isShareAvailable: configuration.behavior.isShareAvailable,
                    .isHostDataProviderEnabled: hasExternalDataProvider,
                ]
            case let .session(flow, product): return [
                    .flow: flow.rawValue,
                    .productId: product.id,
                ]
            case let .startTryOnProcess(origin, product): return [
                    .origin: origin.rawValue,
                    .productId: product.id,
                ]
            case let .error(error, product): return [
                    .error: error.rawValue,
                    .productId: product.id,
                ]
            case let .terminate(product): return [
                    .productId: product.id,
                ]
            case let .success(stats, total, product): return [
                    .productId: product.id,
                    .uploadDuration: stats.uploadDuration,
                    .tryOnDuration: stats.tryOnDuration,
                    .downloadDuration: stats.downloadDuration,
                    .totalDuration: total,
                ]
            case let .share(result, product, page, target): return [
                    .result: result.rawValue,
                    .productId: product.id,
                    .pageId: page.rawValue,
                    .target: target,
                    .error: result.error,
                ]
        }
    }
}

@available(iOS 13.0.0, *)
private extension Aiuta.AuthType {
    var rawValue: String {
        switch self {
            case .apiKey: return "apiKey"
            case .jwt: return "jwt"
        }
    }
}

extension Optional where Wrapped == Aiuta.Product {
    var id: String {
        self?.skuId ?? ""
    }
}

@available(iOS 13.0.0, *)
extension AnalyticEvent.Internal {
    func internalEvent() -> AnalyticEvent {
        AnalyticEvent(name(firstCapitalized: false), parameters())
    }
}

extension Aiuta.Event {
    func internalEvent() -> AnalyticEvent {
        AnalyticEvent(name(firstCapitalized: false), parameters())
    }
}
