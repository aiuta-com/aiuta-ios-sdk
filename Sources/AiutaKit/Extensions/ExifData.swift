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
import ImageIO
import UIKit

@_spi(Aiuta) public final class ExifData: NSObject {
    public var date: Date {
        guard let dateString = dateTimeDigitized ?? dateTimeOriginal else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }

    var colorModel: String?
    var pixelWidth: Double?
    var pixelHeight: Double?
    var dpiWidth: Int?
    var dpiHeight: Int?
    var depth: Int?
    var orientation: Int?
    var apertureValue: String?
    var brightnessValue: String?
    var dateTimeDigitized: String?
    var dateTimeOriginal: String?
    var offsetTime: String?
    var offsetTimeDigitized: String?
    var offsetTimeOriginal: String?
    var model: String?
    var software: String?
    var tileLength: Double?
    var tileWidth: Double?
    var xResolution: Double?
    var yResolution: Double?
    var altitude: String?
    var destBearing: String?
    var hPositioningError: String?
    var imgDirection: String?
    var latitude: String?
    var longitude: String?
    var speed: Double?

    public convenience init?(_ data: Data?) {
        guard let data else { return nil }
        self.init(data)
    }

    public init(_ data: Data) {
        super.init()
        setExifData(data: data as CFData)
    }

    public init(_ url: URL) {
        super.init()

        if let data = NSData(contentsOf: url) {
            setExifData(data: data)
        }
    }

    public init(_ image: UIImage) {
        super.init()

        if let data = image.cgImage?.dataProvider?.data {
            setExifData(data: data)
        }
    }

    func setExifData(data: CFData) {
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        guard let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary),
              let properies = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary)
        else { return }

        let metadata = properies as NSDictionary

        colorModel = metadata[kCGImagePropertyColorModel] as? String
        pixelWidth = metadata[kCGImagePropertyPixelWidth] as? Double
        pixelHeight = metadata[kCGImagePropertyPixelHeight] as? Double
        dpiWidth = metadata[kCGImagePropertyDPIWidth] as? Int
        dpiHeight = metadata[kCGImagePropertyDPIHeight] as? Int
        depth = metadata[kCGImagePropertyDepth] as? Int
        orientation = metadata[kCGImagePropertyOrientation] as? Int

        if let tiffData = metadata[kCGImagePropertyTIFFDictionary] as? NSDictionary {
            model = tiffData[kCGImagePropertyTIFFModel] as? String
            software = tiffData[kCGImagePropertyTIFFSoftware] as? String
            tileLength = tiffData[kCGImagePropertyTIFFTileLength] as? Double
            tileWidth = tiffData[kCGImagePropertyTIFFTileWidth] as? Double
            xResolution = tiffData[kCGImagePropertyTIFFXResolution] as? Double
            yResolution = tiffData[kCGImagePropertyTIFFYResolution] as? Double
        }

        if let exifData = metadata[kCGImagePropertyExifDictionary] as? NSDictionary {
            apertureValue = exifData[kCGImagePropertyExifApertureValue] as? String
            brightnessValue = exifData[kCGImagePropertyExifBrightnessValue] as? String
            dateTimeDigitized = exifData[kCGImagePropertyExifDateTimeDigitized] as? String
            dateTimeOriginal = exifData[kCGImagePropertyExifDateTimeOriginal] as? String
            if #available(iOS 13.0, *) {
                self.offsetTime = exifData[kCGImagePropertyExifOffsetTime] as? String
                self.offsetTimeDigitized = exifData[kCGImagePropertyExifOffsetTimeDigitized] as? String
                self.offsetTimeOriginal = exifData[kCGImagePropertyExifOffsetTimeOriginal] as? String
            }
        }

        if let gpsData = metadata[kCGImagePropertyGPSDictionary] as? NSDictionary {
            altitude = gpsData[kCGImagePropertyGPSAltitude] as? String
            destBearing = gpsData[kCGImagePropertyGPSDestBearing] as? String
            hPositioningError = gpsData[kCGImagePropertyGPSHPositioningError] as? String
            imgDirection = gpsData[kCGImagePropertyGPSImgDirection] as? String
            latitude = gpsData[kCGImagePropertyGPSLatitude] as? String
            longitude = gpsData[kCGImagePropertyGPSLongitude] as? String
            speed = gpsData[kCGImagePropertyGPSSpeed] as? Double
        }
    }
}
