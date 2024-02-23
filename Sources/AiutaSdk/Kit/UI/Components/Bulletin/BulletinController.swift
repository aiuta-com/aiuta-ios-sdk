//
//  Created by nGrey on 06.11.2023.
//

import UIKit

final class BulletinController: UIViewController {
    var bulletin: PlainBulletin?
    weak var presenter: UIViewController?

    convenience init(_ bulletin: PlainBulletin) {
        self.init()
        self.bulletin = bulletin
    }
}
