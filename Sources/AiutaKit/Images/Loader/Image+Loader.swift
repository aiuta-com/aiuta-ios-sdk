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

import Resolver
import UIKit

@_spi(Aiuta) public extension Image {
    var source: ImageSource? {
        get { getAssociatedProperty(&Property.source, ofType: ImageSource.self) ?? image }
        set {
            setAssociatedProperty(&Property.source, newValue: newValue)
            if let newValue { loader = ImageLoader.Cached(newValue, expireAfter: .instant) }
            else { loader = nil }
        }
    }

    var desiredQuality: ImageQuality {
        get { getAssociatedProperty(&Property.desiredQuality, defaultValue: Property.desiredQuality) }
        set { setAssociatedProperty(&Property.desiredQuality, newValue: newValue) }
    }

    var keepCurrentImage: Bool {
        get { getAssociatedProperty(&Property.keepCurrentImage, defaultValue: Property.keepCurrentImage) }
        set { setAssociatedProperty(&Property.keepCurrentImage, newValue: newValue) }
    }

    var isAutoColor: Bool {
        get { getAssociatedProperty(&Property.isAutoColor, defaultValue: Property.isAutoColor) }
        set { setAssociatedProperty(&Property.isAutoColor, newValue: newValue) }
    }
}

@_spi(Aiuta) extension Image: PropertyStoring {
    private struct Property {
        static var source: Void?
        static var loader: Void?
        static var breadcrumbs: Void?
        static var desiredQuality: ImageQuality = .hiResImage
        static var retrievedQuality: Void?
        static var keepCurrentImage: Bool = false
        static var isAutoColor: Bool = false
    }

    var loader: ImageLoader? {
        get { getAssociatedProperty(&Property.loader, ofType: ImageLoader.self) }
        set {
            guard loader != newValue else { return }
            loader?.onImage.cancelSubscription(for: self)
            setAssociatedProperty(&Property.loader, newValue: newValue)
            onChange.fire()

            @Injected var heroic: Heroic

            isAutoSize = false
            retrievedQuality = nil
            if !keepCurrentImage || loader.isNil { image = nil }
            if image.isNil, isAutoColor, let color = loader?.source.backgroundColor {
                view.backgroundColor = color
            }

            newValue?.onImage.subscribePast(with: self) { [unowned self] newImage, quality in
                if let retrievedQuality, retrievedQuality > quality { return }
                if quality > desiredQuality { return }

                retrievedQuality = quality
                if isAutoColor, let color = loader?.source.backgroundColor {
                    view.backgroundColor = color
                }

                guard image != newImage else { return }
                image = newImage
                guard !heroic.isTransitioning, !layout.visibleBounds.size.isAnyZero else { return }
                animations.transition(.transitionCrossDissolve, duration: .thirdOfSecond)
            }

            newValue?.onError.subscribe(with: self) { [unowned self] in
                onError.fire()
            }

            newValue?.load(desiredQuality, breadcrumbs: breadcrumbs.fork())
        }
    }

    var retrievedQuality: ImageQuality? {
        get { getAssociatedProperty(&Property.retrievedQuality, ofType: ImageQuality.self) }
        set { setAssociatedProperty(&Property.retrievedQuality, newValue: newValue) }
    }

    public var breadcrumbs: Breadcrumbs {
        get {
            getAssociatedProperty(&Property.breadcrumbs, ofType: Breadcrumbs.self) ??
                setAssociatedProperty(&Property.breadcrumbs, newValue: Breadcrumbs())
        }
        set { setAssociatedProperty(&Property.breadcrumbs, newValue: newValue) }
    }
}
