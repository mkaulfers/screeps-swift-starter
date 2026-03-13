// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ScreepsSwiftStarter",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "ScreepsKit",
            targets: ["ScreepsKit"]
        ),
        .executable(
            name: "ScreepsSwift",
            targets: ["ScreepsSwift"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftwasm/JavaScriptKit.git",
            from: "0.20.0"
        ),
    ],
    targets: [
        .target(
            name: "ScreepsKit",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        ),
        .executableTarget(
            name: "ScreepsSwift",
            dependencies: [
                "ScreepsKit",
            ]
        ),
        .testTarget(
            name: "ScreepsKitTests",
            dependencies: ["ScreepsKit"]
        ),
    ]
)