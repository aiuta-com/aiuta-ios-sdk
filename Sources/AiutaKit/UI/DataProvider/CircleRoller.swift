//
//  Created by nGrey on 28.11.2023.
//

import Foundation

public final class CircleRoller<DataType> {
    public let didCircle = Signal<Void>()

    private var items: [DataType]
    private var currentIndex: Int = -1

    public init(items: [DataType]) {
        self.items = items
    }

    public func next() -> DataType? {
        guard !items.isEmpty else { return nil }
        let nextIndex = (currentIndex + 1).roll(items.count)
        if nextIndex == items.count - 1 { didCircle.fire() }
        currentIndex = nextIndex
        return items[nextIndex]
    }
}
