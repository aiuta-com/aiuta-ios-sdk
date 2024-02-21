// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AiutaSdk",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "AiutaSdk",
            targets: ["AiutaSdk"]
        ),
        .library(
            name: "AiutaKit",
            targets: ["AiutaKit"]
        ),
        .library(
            name: "Hero",
            targets: ["Hero"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.6.1"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Hero"),
        .target(
            name: "AiutaKit",
            dependencies: [
                "Kingfisher",
                "Resolver",
                .target(name: "Hero"),
            ]
        ),
        .target(
            name: "AiutaSdk",
            dependencies: [
                "Alamofire",
                .target(name: "AiutaKit"),
            ],
            resources: [.process("Resources")]
        )
    ]
)
