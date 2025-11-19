// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "Bourne",
  platforms: [.macOS(.v10_15), .iOS(.v15), .tvOS(.v15), .watchOS(.v6), .macCatalyst(.v15)],
  products: [
    .library(name: "Bourne", targets: ["Bourne"]),
    .executable(name: "BourneClient", targets: ["BourneClient"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "602.0.0"),
  ],
  targets: [
    .macro(
      name: "BourneMacros",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ],
    ),
    .target(name: "Bourne", dependencies: ["BourneMacros"]),
    .executableTarget(name: "BourneClient", dependencies: ["Bourne"]),
    .testTarget(name: "BourneTests", dependencies: ["BourneMacros"]),
  ],
)
