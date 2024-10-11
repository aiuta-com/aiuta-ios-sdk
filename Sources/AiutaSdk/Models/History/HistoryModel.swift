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

protocol HistoryModel {
    var hasUploads: Bool { get }
    var hasGenerations: Bool { get }

    var uploaded: DataProvider<Aiuta.UploadedImage> { get }
    var generated: DataProvider<Aiuta.GeneratedImage> { get }

    func addUploaded(_ image: Aiuta.UploadedImage)
    func touchUploaded(with id: String)
    func removeUploaded(_ image: Aiuta.UploadedImage)

    func addGenerated(_ images: [Aiuta.GeneratedImage])
    func removeGenerated(_ images: [Aiuta.GeneratedImage])
}
