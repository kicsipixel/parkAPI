// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "parkAPI",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-argument-parser",from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "parkAPI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdFoundation", package: "hummingbird")
            ],
            swiftSettings: [
                .unsafeFlags(
                    ["-cross-module-optimization"],
                    .when(configuration: .release)
                )
            ]
        )
    ]
)
