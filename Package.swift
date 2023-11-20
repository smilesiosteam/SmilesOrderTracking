// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmilesOrderTracking",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SmilesOrderTracking",
            targets: ["SmilesOrderTracking"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/smilesiosteam/SmilesUtilities.git", branch: "main"),
        .package(url: "https://github.com/smilesiosteam/SmilesFontsManager.git", branch: "main"),
        .package(url: "https://github.com/YAtechnologies/GoogleMaps-SP.git", .upToNextMinor(from: "7.2.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.18.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SmilesOrderTracking",
            dependencies: [
                .product(name: "SmilesUtilities", package: "SmilesUtilities"),
                .product(name: "SmilesFontsManager", package: "SmilesFontsManager"),
                .product(name: "GoogleMaps", package: "GoogleMaps-SP"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "SmilesOrderTrackingTests",
            dependencies: ["SmilesOrderTracking"]),
    ]
)
