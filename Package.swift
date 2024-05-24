// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "Bourne",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: "Bourne",
      targets: ["Bourne"]
    ),
    .executable(
      name: "BourneClient",
      targets: ["BourneClient"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.2"),
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.2.0")
  ],
  targets: [
    .macro(
      name: "BourneMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),

    .target(name: "Bourne", dependencies: ["BourneMacros"],
     plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
     ),

    .executableTarget(name: "BourneClient", dependencies: ["Bourne"]),

    .testTarget(
      name: "BourneTests",
      dependencies: [
        "BourneMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
        .product(name: "MacroTesting", package: "swift-macro-testing")
      ]
    )
  ]
)
