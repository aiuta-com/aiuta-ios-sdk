// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AiutaSdk",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AiutaKit",
            targets: ["AiutaKit"]
        ),
        .library(
            name: "AiutaSdk",
            targets: ["AiutaSdk"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AiutaKit",
            dependencies: [
                "Alamofire",
                "Kingfisher",
                "Resolver",
            ],
            resources: [.process("Resources")]
        ),
        .target(
            name: "AiutaSdk",
            dependencies: [
                "AiutaKit",
                "Alamofire",
                "Kingfisher",
                "Resolver",
            ],
            resources: [.process("Resources")]
        )
    ]
)
