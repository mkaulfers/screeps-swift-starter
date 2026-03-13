// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ScreepsSwiftStarter",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(
            name: "ScreepsSwift",
            targets: ["ScreepsSwift"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/mkaulfers/ScreepsKit.git",
            from: "0.1.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "ScreepsSwift",
            dependencies: [
                .product(name: "ScreepsKit", package: "ScreepsKit"),
            ]
        ),
        .testTarget(
            name: "ScreepsSwiftStarterTests",
            dependencies: [
                .product(name: "ScreepsKit", package: "ScreepsKit"),
            ]
        ),
    ]
)