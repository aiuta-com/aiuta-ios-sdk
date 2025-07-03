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

enum Sdk {
    static let version = "4.2.0"

    @available(iOS 13.0.0, *)
    @MainActor static var isForeground: Bool {
        return Presenter.isForeground
    }
}

extension Sdk {
    enum Core {
        enum Analytics {}
        enum Api {}
    }

    enum Features {}
    enum UI {}
}
