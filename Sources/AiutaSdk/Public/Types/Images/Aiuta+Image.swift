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

extension Aiuta {
    /// Represents an image used within the SDK. Each image has a unique
    /// identifier, a URL pointing to its location, and a type that describes
    /// its purpose or origin.
    public class Image: Codable {
        /// A unique string identifier assigned to the image by the Aiuta API,
        /// ensuring each image can be distinctly recognized and referenced
        /// within the system.
        public let id: String

        /// The URL pointing to the location of the image resource, which
        /// can be accessed and retrieved by the SDK to present in the UI.
        public let url: String

        /// The type of the image owner indicating whether the image was
        /// generated by the user or provided by Aiuta.
        public let ownerType: OwnerType

        /// Initializes a new `Image` instance with the specified properties.
        ///
        /// - Parameters:
        ///   - id: A unique identifier for the image.
        ///   - url: The URL where the image is located.
        ///   - ownerType: The type of the image owner.
        public init(id: String, url: String, ownerType: OwnerType) {
            self.id = id
            self.url = url
            self.ownerType = ownerType
        }

        /// Initializes a new `Image` instance from a decoder, extracting the necessary
        /// properties from the provided decoder.
        public required init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Aiuta.Image.CodingKeys> = try decoder.container(keyedBy: Aiuta.Image.CodingKeys.self)
            id = try container.decode(String.self, forKey: Aiuta.Image.CodingKeys.id)
            url = try container.decode(String.self, forKey: Aiuta.Image.CodingKeys.url)
            let ownerType = try? container.decode(Aiuta.Image.OwnerType.self, forKey: Aiuta.Image.CodingKeys.ownerType)
            self.ownerType = ownerType ?? .user
        }
    }
}

extension Aiuta.Image {
    /// Represents an image that has been uploaded to the Aiuta system.
    public typealias Input = Aiuta.Image
}

extension Aiuta.Image {
    /// Represents an image that has been generated by the Aiuta system.
    /// This subclass includes additional properties specific to generated images,
    /// such as the IDs of the products associated with the image.
    public class Generated: Aiuta.Image {
        enum CodingKeys: String, CodingKey {
            case productIds
        }

        /// A list of product identifiers that were utilized during the image generation process.
        /// Each identifier corresponds to a specific product involved in the try-on session,
        /// allowing for precise tracking and reference within the system.
        public let productIds: [String]

        /// Initializes a new `Generated` image with the specified properties.
        /// - Parameters:
        ///  - id: A unique identifier for the image.
        ///  - url: The URL where the image is located.
        ///  - ownerType: The type of the image owner.
        ///  - productIds: An array of product identifiers associated with the image.
        public init(id: String, url: String, ownerType: OwnerType, productIds: [String]) {
            self.productIds = productIds
            super.init(id: id, url: url, ownerType: ownerType)
        }

        /// Initializes a `Generated` image from another `Aiuta.Image` instance,
        /// while also specifying the product IDs associated with the image.
        public init(image other: Aiuta.Image, productIds: [String]) {
            self.productIds = productIds
            super.init(id: other.id, url: other.url, ownerType: other.ownerType)
        }

        /// Initializes a `Generated` image from a decoder, extracting the necessary
        /// properties from the provided decoder.
        public required init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let productIds = try? container.decode([String].self, forKey: .productIds)
            self.productIds = productIds ?? []
            try super.init(from: decoder)
        }

        /// Encodes the `Generated` image properties into the provided encoder.
        override public func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(productIds, forKey: .productIds)
        }
    }
}

extension Aiuta.Image {
    /// Owner type primarily determines the source of origin of the image —
    /// whether it was generated by the user as a result of any chain of
    /// operations from upload to generation, possibly including re-generation.
    /// Alternatively, the image is not associated with the user's personal
    /// data and does not belong to them. This allows different approaches
    /// to be taken when deleting images from the history.
    public enum OwnerType: String, Codable {
        /// Image uploaded or generated by the user (using a camera or from a gallery).
        ///
        /// - Note: This image belongs to the user. When the user removes the image
        /// from the history, it may be deleted from the storage as well.
        case user

        /// Image of the model provided or generated by the Aiuta.
        ///
        /// - Note: This image could be linked to the user history, but it is not
        /// owned by the user, and can not be deleted from the storage, only
        /// unlinked from the user's history in case of removing.
        case aiuta
    }
}

extension Aiuta.Image: Equatable {
    /// Compares two `Image` instances to determine if they are equal. Equality
    /// is based on the unique identifier of the image.
    public static func == (lhs: Aiuta.Image, rhs: Aiuta.Image) -> Bool {
        lhs.id == rhs.id
    }
}

extension Aiuta.Image: Hashable {
    /// Generates a hash value for the `Image` instance. The hash is based on
    /// the unique identifier of the image.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
