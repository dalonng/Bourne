# Bourne

一个使用 Swift 宏实现 JSON 自动编解码的库，提供安全的默认值和不可变优先设计。

## 概述

Bourne 使用 Swift 宏自动生成带有合理默认值的 `Codable` 实现。它专为使用 `struct` 和 `let` 的不可变数据模型设计，有助于避免多线程环境中的数据竞争问题。

## 特性

- **自动 Codable 实现**：自动生成 `init(from:)` 和 `encode(to:)` 方法
- **安全的默认值**：缺失的 JSON 键使用默认值而不是抛出错误
- **不可变优先设计**：为 `struct` + `let` 模式设计，提供 `copy()` 方法进行修改
- **空实例**：为每个模型自动生成静态 `.empty` 属性
- **枚举支持**：`@BourneEnum` 宏支持带原始值的枚举
- **自定义属性配置**：`@JSONProperty` 用于自定义默认值和键名
- **线程安全**：自动添加 `Sendable` 协议

## 系统要求

- Swift 6.2+
- macOS 10.15+ / iOS 15+ / tvOS 15+ / watchOS 6+

## 安装

### Swift Package Manager

在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/dalonng/Bourne.git", from: "0.4.0")
]
```

然后将 `Bourne` 添加到目标依赖：

```swift
.target(
    name: "YourTarget",
    dependencies: ["Bourne"]
)
```

## 使用方法

### 使用 `@Bourne` 的基本用法

```swift
import Bourne

@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

这会生成：

- `CodingKeys` 枚举
- 带安全默认值的 `init(from decoder: Decoder)`
- `encode(to encoder: Encoder)`
- `static let empty` - 带默认值的空实例
- `func copy(...)` - 创建修改后的副本

### 使用 `@BourneEnum` 的枚举支持

```swift
@BourneEnum
public enum Gender: String, Sendable {
    case male
    case female
}
```

### 使用 `@JSONProperty` 自定义属性配置

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

参数：

- `defaultValue`：JSON 键缺失时的自定义默认值
- `name`：自定义 JSON 键名（用于 snake_case 到 camelCase 的映射）

### 嵌套模型

```swift
@Bourne
public struct Address {
    public let city: String
    public let street: String
}

@Bourne
public struct PersonWithAddress {
    public let name: String
    public let address: Address  // 如果缺失则使用 Address.empty
}
```

### 使用 Copy 方法

由于模型默认是不可变的，使用 `copy()` 创建修改后的实例：

```swift
let person = Person(name: "Alice", age: 25, isChild: false)
let updatedPerson = person.copy(age: 26)  // 只修改 age
```

## 默认值

当 JSON 键缺失时，Bourne 使用以下默认值：

| 类型 | 默认值 |
|------|--------|
| `String` | `""` |
| `Int` | `0` |
| `Bool` | `false` |
| `Float` / `Double` / `CGFloat` | `0` |
| `Array` | `[]` |
| 自定义 `@Bourne` 类型 | `.empty` |
| 自定义 `@BourneEnum` 类型 | 第一个 case（或通过 `@JSONProperty` 自定义） |

## 生成的代码示例

对于此结构体：

```swift
@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

Bourne 生成：

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

## 许可证

MIT License
