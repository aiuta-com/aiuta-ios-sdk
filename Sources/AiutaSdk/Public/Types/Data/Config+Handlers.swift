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

import Foundation

extension Aiuta.Configuration {
    /// This typealias aggregates all the handlers from different
    /// features of the SDK. Implementing this typealias allows
    /// a single handler to manage multiple features, simplifying
    /// the configuration and management of features in the SDK.
    typealias Handlers =
        Aiuta.Configuration.Features.TryOn.Cart.Handler &
        Aiuta.Analytics.Handler
}
