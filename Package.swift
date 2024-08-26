// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YKSwiftNetworking",
    
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "YKSwiftNetworking", dependencies: ["Alamofire"], path: "Sources"),
        .target(name: "YKSwiftNetworkingRxSwift", dependencies: ["YKSwiftNetworking","RxSwift"], path: "RxSources")
    ],
    
    swiftLanguageVersions: [.v5]
)
