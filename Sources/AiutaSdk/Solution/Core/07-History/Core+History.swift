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

@available(iOS 13.0.0, *)
extension Sdk.Core {
    protocol History {
        var hasUploads: Bool { get }
        var hasGenerations: Bool { get }
        
        var uploaded: DataProvider<Aiuta.Image.Input> { get }
        var generated: DataProvider<Aiuta.Image.Generated> { get }
        
        var deletingUploaded: DataProvider<Aiuta.Image.Input> { get }
        var deletingGenerated: DataProvider<Aiuta.Image.Generated> { get }
        
        func addUploaded(_ image: Aiuta.Image.Input) async throws
        func touchUploaded(with id: String) async throws -> Bool
        func removeUploaded(_ image: Aiuta.Image.Input) async throws
        
        func addGenerated(_ images: [Aiuta.Image], for products: Aiuta.Products) async throws
        func removeGenerated(_ images: [Aiuta.Image.Generated]) async throws
    }
}
