//
// Created by nGrey on 01.03.2023.
//

import UIKit

public final class Appearance<ViewType> where ViewType: UIView {
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
