// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceCore",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ServiceCore",
            targets: ["ServiceCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Incetro/codex.git", from: "0.2.4"),
        .package(url: "https://github.com/Incetro/http-transport.git", from: "5.2.8"),
        .package(url: "https://github.com/Incetro/combine-extensions.git", .branch("main"))
    ],
    targets: [
        .target(
            name: "ServiceCore",
            dependencies: [
                .product(name: "CombineExtensions", package: "combine-extensions"),
                .product(name: "Codex", package: "codex"),
                .product(name: "HTTPTransport", package: "http-transport")
            ]
        ),
        .testTarget(
            name: "ServiceCoreTests",
            dependencies: ["ServiceCore"]
        ),
    ]
)
