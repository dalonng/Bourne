# Bourne

Swift マクロを使用した JSON 自動エンコード/デコードライブラリ。安全なデフォルト値とイミュータブルファーストの設計を提供します。

## 概要

Bourne は Swift マクロを使用して、適切なデフォルト値を持つ `Codable` 実装を自動生成します。`struct` と `let` を使用したイミュータブルなデータモデル向けに設計されており、マルチスレッド環境でのデータ競合問題を回避するのに役立ちます。

## 機能

- **自動 Codable 実装**：`init(from:)` と `encode(to:)` メソッドを自動生成
- **安全なデフォルト値**：欠落した JSON キーはエラーをスローせずデフォルト値を使用
- **イミュータブルファースト設計**：`struct` + `let` パターン向けに設計、変更用の `copy()` メソッドを提供
- **空インスタンス**：各モデルに静的な `.empty` プロパティを自動生成
- **enum サポート**：raw value を持つ enum 用の `@BourneEnum` マクロ
- **カスタムプロパティ設定**：カスタムデフォルト値とキー名用の `@JSONProperty`
- **スレッドセーフ**：`Sendable` 準拠を自動追加

## 要件

- Swift 6.2+
- macOS 10.15+ / iOS 15+ / tvOS 15+ / watchOS 6+

## インストール

### Swift Package Manager

`Package.swift` に追加：

```swift
dependencies: [
    .package(url: "https://github.com/dalonng/Bourne.git", from: "0.4.0")
]
```

次に `Bourne` をターゲットの依存関係に追加：

```swift
.target(
    name: "YourTarget",
    dependencies: ["Bourne"]
)
```

## 使用方法

### `@Bourne` の基本的な使用法

```swift
import Bourne

@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

これにより以下が生成されます：

- `CodingKeys` enum
- 安全なデフォルト値を持つ `init(from decoder: Decoder)`
- `encode(to encoder: Encoder)`
- `static let empty` - デフォルト値を持つ空のインスタンス
- `func copy(...)` - 変更されたコピーを作成

### `@BourneEnum` による enum サポート

```swift
@BourneEnum
public enum Gender: String, Sendable {
    case male
    case female
}
```

### `@JSONProperty` によるカスタムプロパティ設定

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

パラメータ：

- `defaultValue`：JSON キーが欠落している場合のカスタムデフォルト値
- `name`：カスタム JSON キー名（snake_case から camelCase へのマッピング用）

### ネストされたモデル

```swift
@Bourne
public struct Address {
    public let city: String
    public let street: String
}

@Bourne
public struct PersonWithAddress {
    public let name: String
    public let address: Address  // 欠落している場合は Address.empty を使用
}
```

### Copy メソッドの使用

モデルはデフォルトでイミュータブルなので、`copy()` を使用して変更されたインスタンスを作成します：

```swift
let person = Person(name: "Alice", age: 25, isChild: false)
let updatedPerson = person.copy(age: 26)  // age のみ変更
```

## デフォルト値

JSON キーが欠落している場合、Bourne は以下のデフォルト値を使用します：

| 型 | デフォルト値 |
|----|-------------|
| `String` | `""` |
| `Int` | `0` |
| `Bool` | `false` |
| `Float` / `Double` / `CGFloat` | `0` |
| `Array` | `[]` |
| カスタム `@Bourne` 型 | `.empty` |
| カスタム `@BourneEnum` 型 | 最初のケース（または `@JSONProperty` でカスタム指定） |

## 生成されるコード例

この構造体の場合：

```swift
@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

Bourne は以下を生成します：

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

## ライセンス

MIT License
