// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YKSwiftNetworking",
    products: [
        .library(name: "YKSwiftNetworking", targets: ["YKSwiftNetworking"])
        
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "YKSwiftNetworking", 
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
