//
//  Created by nGrey on 19.04.2023.
//

import UIKit

public protocol StyleRef {
    var font: FontRef? { get }
    var foregroundColor: UIColor? { get }
    var backgroundColor: UIColor? { get }
    var borderWidth: CGFloat? { get }
    var cornerRadius: CGFloat? { get }
    var designedHeight: CGFloat? { get }
}
