// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "BourneMacros", type: "StringifyMacro")

@attached(peer, names: overloaded)
public macro AddAsync() = #externalMacro(module: "BourneMacros", type: "AddAsyncMacro")

@attached(peer)
public macro BourneJson() = #externalMacro(module: "BourneMacros", type: "BourneJsonMacro")

@attached(member, names: arbitrary)
public macro AutoCodable() = #externalMacro(module: "BourneMacros", type: "AutoCodableMacro")
