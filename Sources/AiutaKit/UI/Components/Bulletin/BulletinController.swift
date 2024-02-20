//
//  Created by nGrey on 06.11.2023.
//

import UIKit

public final class BulletinController: UIViewController {
    public var bulletin: PlainBulletin?
    public weak var presenter: UIViewController?

    public convenience init(_ bulletin: PlainBulletin) {
        self.init()
        self.bulletin = bulletin
    }
}
