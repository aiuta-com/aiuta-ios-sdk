// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if canImport(UIKit)
import CoreGraphics
import QuartzCore

enum HeroSnapshotType {
  /// Will optimize for different type of views
  /// For custom views or views with masking, .optimizedDefault might create snapshots 
  /// that appear differently than the actual view.
  /// In that case, use .normal or .slowRender to disable the optimization
  case optimized

  /// snapshotView(afterScreenUpdates:)
  case normal

  /// layer.render(in: currentContext)
  case layerRender

  /// will not create snapshot. animate the view directly.
  /// This will mess up the view hierarchy, therefore, view controllers have to rebuild
  /// its view structure after the transition finishes
  case noSnapshot
}

enum HeroCoordinateSpace {
  case global
  case local
}

struct HeroTargetState {
  var beginState: [HeroModifier]?
  var conditionalModifiers: [((HeroConditionalContext) -> Bool, [HeroModifier])]?

  var position: CGPoint?
  var size: CGSize?
  var transform: CATransform3D?
  var opacity: Float?
  var cornerRadius: CGFloat?
  var backgroundColor: CGColor?
  var zPosition: CGFloat?
  var anchorPoint: CGPoint?

  var contentsRect: CGRect?
  var contentsScale: CGFloat?

  var borderWidth: CGFloat?
  var borderColor: CGColor?

  var shadowColor: CGColor?
  var shadowOpacity: Float?
  var shadowOffset: CGSize?
  var shadowRadius: CGFloat?
  var shadowPath: CGPath?
  var masksToBounds: Bool?
  var displayShadow: Bool = true

  var overlay: (color: CGColor, opacity: CGFloat)?

  var spring: (CGFloat, CGFloat)?
  var delay: TimeInterval = 0
  var duration: TimeInterval?
  var timingFunction: CAMediaTimingFunction?

  var arc: CGFloat?
  var source: String?
  var cascade: (TimeInterval, CascadeDirection, Bool)?

  var ignoreSubviewModifiers: Bool?
  var coordinateSpace: HeroCoordinateSpace?
  var useScaleBasedSizeChange: Bool?
  var snapshotType: HeroSnapshotType?

  var nonFade: Bool = false
  var forceAnimate: Bool = false
  var custom: [String: Any]?

  init(modifiers: [HeroModifier]) {
    append(contentsOf: modifiers)
  }

  mutating func append(_ modifier: HeroModifier) {
    modifier.apply(&self)
  }

  mutating func append(contentsOf modifiers: [HeroModifier]) {
    for modifier in modifiers {
      modifier.apply(&self)
    }
  }

  /**
   - Returns: custom item for a specific key
   */
  subscript(key: String) -> Any? {
    get {
      return custom?[key]
    }
    set {
      if custom == nil {
        custom = [:]
      }
      custom![key] = newValue
    }
  }
}

extension HeroTargetState: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: HeroModifier...) {
    append(contentsOf: elements)
  }
}
#endif
