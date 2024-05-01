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

@_spi(Aiuta) public struct Zip<Sequence1: Sequence, Sequence2: Sequence> {
    private let sequence1: Sequence1?
    private let sequence2: Sequence2?

    public init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
        (self.sequence1, self.sequence2) = (sequence1, sequence2)
    }
}

extension Zip {
    @_spi(Aiuta) public struct ShortestSequence: Sequence {
        internal let sequence1: Sequence1?
        internal let sequence2: Sequence2?

        internal init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
            (self.sequence1, self.sequence2) = (sequence1, sequence2)
        }

        public struct Iterator: IteratorProtocol {
            public typealias Element = (Sequence1.Iterator.Element, Sequence2.Iterator.Element)

            internal var iterator1: Sequence1.Iterator?
            internal var iterator2: Sequence2.Iterator?
            internal var reachedEnd = false

            internal init(_ iterator1: Sequence1.Iterator?, _ iterator2: Sequence2.Iterator?) {
                (self.iterator1, self.iterator2) = (iterator1, iterator2)
            }

            public mutating func next() -> Element? {
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

        public func makeIterator() -> Iterator {
            return Iterator(sequence1?.makeIterator(), sequence2?.makeIterator())
        }
    }
}

@_spi(Aiuta) public extension Zip {
    var shortest: ShortestSequence {
        return ShortestSequence(sequence1, sequence2)
    }
}

extension Zip {
    @_spi(Aiuta) public struct LongestSequence: Sequence {
        internal let sequence1: Sequence1?
        internal let sequence2: Sequence2?

        internal init(_ sequence1: Sequence1?, _ sequence2: Sequence2?) {
            (self.sequence1, self.sequence2) = (sequence1, sequence2)
        }

        public struct Iterator: IteratorProtocol {
            public typealias Element = (Sequence1.Iterator.Element?, Sequence2.Iterator.Element?)

            internal var iterator1: Sequence1.Iterator?
            internal var iterator2: Sequence2.Iterator?
            internal var reachedEnd = false

            internal init(_ iterator1: Sequence1.Iterator?, _ iterator2: Sequence2.Iterator?) {
                (self.iterator1, self.iterator2) = (iterator1, iterator2)
            }

            public mutating func next() -> Element? {
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

        public func makeIterator() -> Iterator {
            return Iterator(sequence1?.makeIterator(), sequence2?.makeIterator())
        }
    }
}

@_spi(Aiuta) public extension Zip {
    var longest: LongestSequence {
        return LongestSequence(sequence1, sequence2)
    }
}
