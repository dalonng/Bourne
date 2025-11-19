// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@attached(extension, conformances: Decodable, Encodable, Sendable, names: arbitrary)
@attached(member, names: arbitrary)
public macro Bourne() = #externalMacro(module: "BourneMacros", type: "BourneMacro")

@attached(peer, names: arbitrary)
public macro JSONProperty(defaultValue: Any? = nil, name: String = "") = #externalMacro(module: "BourneMacros", type: "JSONPropertyMacro")

@attached(extension, conformances: Decodable, Encodable, Sendable, names: arbitrary)
@attached(member, names: arbitrary)
public macro BourneEnum() = #externalMacro(module: "BourneMacros", type: "BourneEnumMacro")
