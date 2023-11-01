// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CMHUD",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CMHUD",
            targets: ["CMHUD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Incetro/toast.git", .branch("main")),
        .package(url: "https://github.com/Incetro/layout.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CMHUD",
            dependencies: [
                .product(name: "Toast", package: "toast"),
                .product(name: "Layout", package: "layout")
            ]
        ),
        .testTarget(
            name: "CMHUDTests",
            dependencies: ["CMHUD"]),
    ]
)
