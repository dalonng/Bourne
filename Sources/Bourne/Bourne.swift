// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@attached(extension, names: arbitrary)
public macro Bourne() = #externalMacro(module: "BourneMacros", type: "BourneMacro")

@attached(peer, names: arbitrary)
public macro JSONProperty(defaultValue: Any? = nil, name: String = "") = #externalMacro(module: "BourneMacros", type: "JSONPropertyMacro")
