// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AiutaSdk",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AiutaCore",
            targets: ["AiutaCore"]
        ),
        .library(
            name: "AiutaKit",
            targets: ["AiutaKit"]
        ),
        .library(
            name: "AiutaConfig",
            targets: ["AiutaConfig"]
        ),
        .library(
            name: "AiutaDefaults",
            targets: ["AiutaDefaults"]
        ),
        .library(
            name: "AiutaAssets",
            targets: ["AiutaAssets"]
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
            name: "AiutaCore",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AiutaKit",
            dependencies: [
                "Alamofire",
                "Kingfisher",
                "Resolver",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AiutaConfig",
            dependencies: [
                "AiutaCore",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AiutaDefaults",
            dependencies: [
                "AiutaConfig",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AiutaAssets",
            dependencies: [
                "AiutaDefaults",
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AiutaSdk",
            dependencies: [
                "AiutaCore",
                "AiutaConfig",
                "AiutaDefaults",
                "AiutaKit",
                "AiutaAssets",
                "Alamofire",
                "Kingfisher",
                "Resolver",
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
