//
//  Created by nGrey on 29.11.2023.
//

import Foundation

struct Zip<Sequence1: Sequence, Sequence2: Sequence> {
    private let sequence1: Sequence1?
    private let sequence2: Sequence2?

    init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
        (self.sequence1, self.sequence2) = (sequence1, sequence2)
    }
}

extension Zip {
    struct ShortestSequence: Sequence {
        internal let sequence1: Sequence1?
        internal let sequence2: Sequence2?

        internal init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
            (self.sequence1, self.sequence2) = (sequence1, sequence2)
        }

        struct Iterator: IteratorProtocol {
            typealias Element = (Sequence1.Iterator.Element, Sequence2.Iterator.Element)

            internal var iterator1: Sequence1.Iterator?
            internal var iterator2: Sequence2.Iterator?
            internal var reachedEnd = false

            internal init(_ iterator1: Sequence1.Iterator?, _ iterator2: Sequence2.Iterator?) {
                (self.iterator1, self.iterator2) = (iterator1, iterator2)
            }

            mutating func next() -> Element? {
                if reachedEnd {
                    return nil
                }

                guard let element1 = iterator1?.next(), let element2 = iterator2?.next() else {
                    reachedEnd.toggle()

                    return nil
                }

                return (element1, element2)
            }
        }

        func makeIterator() -> Iterator {
            return Iterator(sequence1?.makeIterator(), sequence2?.makeIterator())
        }
    }
}

extension Zip {
    var shortest: ShortestSequence {
        return ShortestSequence(sequence1, sequence2)
    }
}

extension Zip {
    struct LongestSequence: Sequence {
        internal let sequence1: Sequence1?
        internal let sequence2: Sequence2?

        internal init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
            (self.sequence1, self.sequence2) = (sequence1, sequence2)
        }

        struct Iterator: IteratorProtocol {
            typealias Element = (Sequence1.Iterator.Element?, Sequence2.Iterator.Element?)

            internal var iterator1: Sequence1.Iterator?
            internal var iterator2: Sequence2.Iterator?
            internal var reachedEnd = false

            internal init(_ iterator1: Sequence1.Iterator?, _ iterator2: Sequence2.Iterator?) {
                (self.iterator1, self.iterator2) = (iterator1, iterator2)
            }

            mutating func next() -> Element? {
                if reachedEnd {
                    return nil
                }

                let element1 = iterator1?.next()
                let element2 = iterator2?.next()

                if element1 == nil && element2 == nil {
                    reachedEnd.toggle()

                    return nil
                }

                return (element1, element2)
            }
        }

        func makeIterator() -> Iterator {
            return Iterator(sequence1?.makeIterator(), sequence2?.makeIterator())
        }
    }
}

extension Zip {
    var longest: LongestSequence {
        return LongestSequence(sequence1, sequence2)
    }
}
