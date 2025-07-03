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

final class RectBatching {
    private(set) var batches = [RectBatch]()

    var count: Int {
        guard let last = batches.last else { return 0 }
        return last.count + RectBatch.batchSize * (batches.count - 1)
    }

    func add(_ rect: CGRect) {
        if let batch = batches.last, batch.canFit {
            batch.add(rect)
            return
        }

        let batch = RectBatch(startIndex: batches.count * RectBatch.batchSize)
        batches.append(batch)
        batch.add(rect)
    }

    func removeAll() {
        batches.removeAll(keepingCapacity: true)
    }
}

final class RectBatch {
    static let batchSize: Int = 20

    private(set) var frame: CGRect = .init(x: .greatestFiniteMagnitude, y: .greatestFiniteMagnitude, size: .zero)
    private var rects = [CGRect]()

    private let startIndex: Int

    var count: Int {
        rects.count
    }

    var canFit: Bool {
        rects.count < RectBatch.batchSize
    }

    init(startIndex: Int) {
        self.startIndex = startIndex
    }

    func add(_ rect: CGRect) {
        rects.append(rect)
        if rect.minX < frame.minX {
            frame.origin.x = rect.origin.x
        }
        if rect.minY < frame.minY {
            frame.origin.y = rect.origin.y
        }
        if rect.maxX > frame.maxX {
            frame.size.width = rect.maxX - frame.minX
        }
        if rect.maxY > frame.maxY {
            frame.size.height = rect.maxY - frame.minY
        }
    }

    func forEachRect(_ iterator: (Int, CGRect) -> Void) {
        rects.indexed.forEach { i, rect in
            iterator(startIndex + i, rect)
        }
    }
}
