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

extension Sdk {
    static func validate(_ coniguration: Configuration) {
    }
}

fileprivate extension Sdk.Configuration {
    
}
    
//        private func checkIfUsageDescriptionsProvided(_ config: Aiuta.OldConfiguration.Behavior) {
//            @bundle(key: "NSCameraUsageDescription")
//            var cameraUsageDescription: String?
//
//            if config.isCameraAvailable, cameraUsageDescription.isNullOrEmpty {
//                NSLog("Please provide NSCameraUsageDescription in your Info.plist so that Aiuta can request permission to use the camera from the user.")
//            }
//
//            @bundle(key: "NSPhotoLibraryAddUsageDescription")
//            var photoLibraryAddUsageDescription: String?
//
//            if photoLibraryAddUsageDescription.isNullOrEmpty {
//                NSLog("Please provide NSPhotoLibraryAddUsageDescription in your Info.plist so that Aiuta can request permission " +
//                    "to save the generated image to the Photo Gallery from the user.")
//            }
//        }
