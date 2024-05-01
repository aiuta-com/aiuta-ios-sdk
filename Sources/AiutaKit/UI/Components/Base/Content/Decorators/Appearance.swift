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

@_spi(Aiuta) public final class Appearance<ViewType> where ViewType: UIView {
    private let view: ViewType
    private var snapshot: UIView?

    public required init(view: ViewType) {
        self.view = view
    }

    public func make(_ closure: (_ make: ViewType) -> Void) {
        closure(view)
    }
    
    public func freeze(afterScreenUpdates: Bool = false) {
        guard snapshot.isNil else { return }
        snapshot = view.snapshotView(afterScreenUpdates: afterScreenUpdates)
        snapshot?.isUserInteractionEnabled = false
        if let snapshot { view.addSubview(snapshot) }
    }
    
    public func unfreeze() {
        snapshot?.removeFromSuperview()
        snapshot = nil
    }
}
