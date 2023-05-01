// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Giffy",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Giffy",
            targets: ["Giffy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", .upToNextMajor(from: "1.0.17"))
    ],
    targets: [
        .target(
            name: "Giffy",
            dependencies: ["FLAnimatedImage"]),
        .testTarget(
            name: "GiffyTests",
            dependencies: ["Giffy"]),
    ]
)
