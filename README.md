# Bourne

A Swift macro library for automatic JSON encoding/decoding with safe defaults and immutable-first design.

## Overview

Bourne uses Swift macros to automatically generate `Codable` implementations with sensible defaults. It's designed for immutable data models using `struct` and `let`, which helps avoid data race issues in multi-threaded environments.

## Features

- **Automatic Codable Implementation**: Generate `init(from:)` and `encode(to:)` methods automatically
- **Safe Defaults**: Missing JSON keys use default values instead of throwing errors
- **Immutable-First Design**: Designed for `struct` + `let` patterns with a `copy()` method for modifications
- **Empty Instance**: Auto-generates a static `.empty` property for each model
- **Enum Support**: `@BourneEnum` macro for enums with raw values
- **Custom Property Configuration**: `@JSONProperty` for custom default values and key names
- **Thread-Safe**: `Sendable` conformance automatically added

## Requirements

- Swift 6.2+
- macOS 10.15+ / iOS 15+ / tvOS 15+ / watchOS 6+

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dalonng/Bourne.git", from: "0.4.0")
]
```

Then add `Bourne` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Bourne"]
)
```

## Usage

### Basic Usage with `@Bourne`

```swift
import Bourne

@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

This generates:

- `CodingKeys` enum
- `init(from decoder: Decoder)` with safe defaults
- `encode(to encoder: Encoder)`
- `static let empty` - an empty instance with default values
- `func copy(...)` - create a modified copy

### Enum Support with `@BourneEnum`

```swift
@BourneEnum
public enum Gender: String, Sendable {
    case male
    case female
}
```

### Custom Property Configuration with `@JSONProperty`

```swift
@Bourne
public struct User {
    public let name: String

    @JSONProperty(defaultValue: 18)
    public let age: Int

    @JSONProperty(name: "user_email")
    public let email: String

    @JSONProperty(defaultValue: Gender.male, name: "user_gender")
    public let gender: Gender
}
```

Parameters:

- `defaultValue`: Custom default value when JSON key is missing
- `name`: Custom JSON key name (for snake_case to camelCase mapping)

### Nested Models

```swift
@Bourne
public struct Address {
    public let city: String
    public let street: String
}

@Bourne
public struct PersonWithAddress {
    public let name: String
    public let address: Address  // Uses Address.empty if missing
}
```

### Using the Copy Method

Since models are immutable by default, use `copy()` to create modified instances:

```swift
let person = Person(name: "Alice", age: 25, isChild: false)
let updatedPerson = person.copy(age: 26)  // Only changes age
```

## Default Values

When a JSON key is missing, Bourne uses these defaults:

| Type | Default Value |
|------|---------------|
| `String` | `""` |
| `Int` | `0` |
| `Bool` | `false` |
| `Float` / `Double` / `CGFloat` | `0` |
| `UUID` | `UUID()` (new random UUID) |
| `Array` | `[]` |
| Custom `@Bourne` types | `.empty` |
| Custom `@BourneEnum` types | First case (or custom via `@JSONProperty`) |

## Generated Code Example

For this struct:

```swift
@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

Bourne generates:

```swift
extension Person: Decodable, Encodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case isChild
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        self.isChild = try container.decodeIfPresent(Bool.self, forKey: .isChild) ?? false
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(isChild, forKey: .isChild)
    }

    public static let empty = Person(
        name: "",
        age: 0,
        isChild: false
    )

    public func copy(
        name: String? = nil,
        age: Int? = nil,
        isChild: Bool? = nil
    ) -> Person {
        Person(
            name: name ?? self.name,
            age: age ?? self.age,
            isChild: isChild ?? self.isChild
        )
    }
}
```

## Documentation

- [中文文档](README_CN.md)
- [日本語ドキュメント](README_JA.md)
- [한국어 문서](README_KO.md)

## License

MIT License
