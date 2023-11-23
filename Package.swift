// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Zeus",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "Zeus",
            targets: [
                "Zeus"
            ]
        ),
        .library(
            name: "ZeusKit",
            targets: [
                "Zeus"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.7.0"
        ),
    ],
    targets: [
        .target(
            name: "Zeus",
            dependencies: [
                "Alamofire"
            ]
            
        ),
        .testTarget(
            name: "ZeusTests",
            dependencies: [
                "Zeus"
            ]
        ),
    ]
)
