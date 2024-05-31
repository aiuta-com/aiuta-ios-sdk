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
import UIKit

protocol AiutaSdkModel {
    var onChangeState: Signal<Aiuta.SessionState> { get }
    var onChangeSku: Signal<Aiuta.SkuInfo> { get }
    var onChangeResults: Signal<([Aiuta.GeneratedImage], Aiuta.SkuInfo)> { get }
    var onChangeHistory: Signal<[Aiuta.GeneratedImage]> { get }
    var onChangeUploads: Signal<[Aiuta.UploadedImage]> { get }
    var onStatus: Signal<String> { get }
    var onError: Signal<String> { get }

    var state: Aiuta.SessionState { get }
    var tryOnSku: Aiuta.SkuInfo? { get set }
    var moreToTryOn: [Aiuta.SkuInfo] { get }
    var uploadsHistory: [[Aiuta.UploadedImage]] { get set }
    var generationHistory: [Aiuta.GeneratedImage] { get set }
    var generationResults: [Aiuta.SessionResult] { get }

    var delegate: AiutaSdkDelegate? { get }

    func startSession(_ session: Aiuta.TryOnSession)
    func startTryOn(_ input: Aiuta.Inputs, origin: AnalyticEvent.TryOn.Origin)

    func preloadImage(_ url: String?)

    func eraseHistoryIfNeeded()
}

extension Aiuta {
    enum ProcessingState: Comparable {
        case uploadingImage
        case scanningBody
        case generatingOutfit
        case failed
    }

    enum SessionState: Comparable {
        case initial
        case photoSelecting
        case processing(ProcessingState)
        case result
    }

    enum SessionResult: Equatable {
        case input(Aiuta.Input, Aiuta.SkuInfo)
        case output(Aiuta.GeneratedImage, Aiuta.SkuInfo)
        case sku(Aiuta.SkuInfo)
    }
}
