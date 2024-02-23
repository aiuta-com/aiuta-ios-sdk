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
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.6.1"),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.0.0"),
        .package(url: "https://github.com/HeroTransitions/Hero.git", from: "1.6.2")
    ],
    targets: [
        .target(
            name: "AiutaSdk",
            dependencies: [
                "Alamofire",
                "Kingfisher",
                "Resolver",
                "Hero"
            ],
            resources: [.process("Resources")]
        )
    ]
)
