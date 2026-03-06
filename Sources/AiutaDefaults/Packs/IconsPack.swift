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

public struct IconsPack: Sendable {
    // PageBar
    public let back24: UIImage
    public let close24: UIImage
    // Selection
    public let trash24: UIImage
    public let check20: UIImage
    // Error
    public let error36: UIImage
    // Image
    public let imageError36: UIImage
    // ProductBar
    public let arrow16: UIImage
    // ActivityIndicator
    public let loading14: UIImage?
    // ImagePicker
    public let camera24: UIImage
    public let gallery24: UIImage
    public let selectModels24: UIImage
    // TryOn
    public let magic20: UIImage
    public let changePhoto24: UIImage
    public let history24: UIImage
    // Feedback
    public let like36: UIImage
    public let dislike36: UIImage
    // Share
    public let share24: UIImage
    // Wishlist (optional — feature is disabled by default)
    public let wishlist24: UIImage?
    public let wishlistFill24: UIImage?

    public init(back24: UIImage,
                close24: UIImage,
                trash24: UIImage,
                check20: UIImage,
                error36: UIImage,
                imageError36: UIImage,
                arrow16: UIImage,
                loading14: UIImage?,
                camera24: UIImage,
                gallery24: UIImage,
                selectModels24: UIImage,
                magic20: UIImage,
                changePhoto24: UIImage,
                history24: UIImage,
                like36: UIImage,
                dislike36: UIImage,
                share24: UIImage,
                wishlist24: UIImage? = nil,
                wishlistFill24: UIImage? = nil) {
        self.back24 = back24
        self.close24 = close24
        self.trash24 = trash24
        self.check20 = check20
        self.error36 = error36
        self.imageError36 = imageError36
        self.arrow16 = arrow16
        self.loading14 = loading14
        self.camera24 = camera24
        self.gallery24 = gallery24
        self.selectModels24 = selectModels24
        self.magic20 = magic20
        self.changePhoto24 = changePhoto24
        self.history24 = history24
        self.like36 = like36
        self.dislike36 = dislike36
        self.share24 = share24
        self.wishlist24 = wishlist24
        self.wishlistFill24 = wishlistFill24
    }
}
