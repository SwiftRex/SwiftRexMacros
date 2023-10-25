// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftRexMacros",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "SwiftRexMacros", targets: ["SwiftRexMacros"]),
        .executable(name: "SwiftRexMacrosClient", targets: ["SwiftRexMacrosClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        .macro(
            name: "PrismMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftRexMacros", dependencies: ["PrismMacro"]),
        .executableTarget(name: "SwiftRexMacrosClient", dependencies: ["SwiftRexMacros"]),
        .testTarget(
            name: "SwiftRexMacrosTests",
            dependencies: [
                "PrismMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        )
    ]
)
