//
//  Created by nGrey on 01.06.2023.
//

import Foundation

extension URL {
    init? (string: String?) {
        guard let string else { return nil }
        self.init(string: string)
    }
}
