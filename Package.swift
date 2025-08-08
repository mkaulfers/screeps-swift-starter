// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ScreepsSwift",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .executable(
            name: "ScreepsSwift",
            targets: ["ScreepsSwift"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftwasm/JavaScriptKit.git",
            from: "0.19.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "ScreepsSwift",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        ),
    ]
)