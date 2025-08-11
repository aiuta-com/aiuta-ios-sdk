![aiuta_banner](https://docs.aiuta.com/media/about.png)

# Aiuta Virtual Try-On SDK for iOS

This repo distributes the [Aiuta Virtual Try-On](https://aiuta.com/virtual-try-on) library via Swift Package Manager.

## Installation

### Swift Package Manager

Add AiutaSdk as a `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/aiuta-com/aiuta-ios-sdk.git", from: "4.0.0")
]
```

Add dependency to your target

```swift
.product(name: "AiutaSdk", package: "aiuta-ios-sdk")
```

## Permissions

Please provide following descriptions in your `Info.plist` file:

- `NSCameraUsageDescription` to request permission from the user to use the camera. This is called `Privacy - Camera Usage Description` in the visual editor.
- `NSPhotoLibraryAddUsageDescription` to request permission to save the generated image to the Photo Gallery from the user. This is called `Privacy - Photo Library Usage Description` in the visual editor.

## Documentation

Full documentation can be found [here](https://docs.aiuta.com/sdk/ios/).

## License

    Copyright 2024 Aiuta USA, Inc

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

           http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
