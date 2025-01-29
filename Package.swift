// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "Bourne",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(name: "Bourne", targets: ["Bourne"]),
    .executable(name: "BourneClient", targets: ["BourneClient"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.1"),
    .package(url: "https://github.com/stackotter/swift-macro-toolkit.git", from: "0.6.0"),
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.5.2")

  ],
  targets: [
    .macro(
      name: "BourneMacros",
      dependencies: [
        .product(name: "MacroToolkit", package: "swift-macro-toolkit"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .target(name: "Bourne", dependencies: ["BourneMacros"]),
    .executableTarget(
      name: "BourneClient",
      dependencies: [
        "Bourne",
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),
    .testTarget(name: "BourneTests", dependencies: [
      "BourneMacros",
      .product(name: "SwiftSyntax", package: "swift-syntax"),
      .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      .product(name: "MacroTesting", package: "swift-macro-testing")

    ])
  ]
)
