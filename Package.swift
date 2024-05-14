// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "Bourne",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Bourne",
      targets: ["Bourne"]
    ),
    .executable(
      name: "BourneClient",
      targets: ["BourneClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.2"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "BourneMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(name: "Bourne", dependencies: ["BourneMacros"]),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(name: "BourneClient", dependencies: ["Bourne"]),

    // A test target used to develop the macro implementation.
    .testTarget(
      name: "BourneTests",
      dependencies: [
        "BourneMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ]
)
