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

import UIKit

@_spi(Aiuta) extension UIImage: ImageSource {
    public var knownRemoteId: String? { nil }
    public var transitionId: String { uuid }

    public func fetcher(for quality: ImageQuality, breadcrumbs: Breadcrumbs) -> ImageFetcher {
        Downsampler(self, quality: quality, breadcrumbs: breadcrumbs)
    }
}

@_spi(Aiuta) public extension UIImage {
    private struct Property {
        static var uuid: Void?
    }

    var uuid: String {
        getAssociatedProperty(&Property.uuid, ofType: String.self) ??
            setAssociatedProperty(&Property.uuid, newValue: UUID().uuidString)
    }
}
