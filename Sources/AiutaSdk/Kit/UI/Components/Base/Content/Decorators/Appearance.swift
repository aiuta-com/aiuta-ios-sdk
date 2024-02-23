//
// Created by nGrey on 01.03.2023.
//

import UIKit

final class Appearance<ViewType> where ViewType: UIView {
    private let view: ViewType
    private var snapshot: UIView?

    required init(view: ViewType) {
        self.view = view
    }

    func make(_ closure: (_ make: ViewType) -> Void) {
        closure(view)
    }
    
    func freeze(afterScreenUpdates: Bool = false) {
        guard snapshot.isNil else { return }
        snapshot = view.snapshotView(afterScreenUpdates: afterScreenUpdates)
        snapshot?.isUserInteractionEnabled = false
        if let snapshot { view.addSubview(snapshot) }
    }
    
    func unfreeze() {
        snapshot?.removeFromSuperview()
        snapshot = nil
    }
}
