# Bourne

안전한 기본값과 불변성 우선 설계를 제공하는 Swift 매크로 기반 JSON 자동 인코딩/디코딩 라이브러리입니다.

## 개요

Bourne은 Swift 매크로를 사용하여 합리적인 기본값을 가진 `Codable` 구현을 자동 생성합니다. `struct`와 `let`을 사용하는 불변 데이터 모델을 위해 설계되어 멀티스레드 환경에서 데이터 경쟁 문제를 방지하는 데 도움이 됩니다.

## 기능

- **자동 Codable 구현**: `init(from:)` 및 `encode(to:)` 메서드 자동 생성
- **안전한 기본값**: 누락된 JSON 키는 오류를 발생시키지 않고 기본값 사용
- **불변성 우선 설계**: `struct` + `let` 패턴을 위해 설계되었으며 수정을 위한 `copy()` 메서드 제공
- **빈 인스턴스**: 각 모델에 정적 `.empty` 속성 자동 생성
- **열거형 지원**: raw value를 가진 열거형을 위한 `@BourneEnum` 매크로
- **사용자 정의 속성 설정**: 사용자 정의 기본값과 키 이름을 위한 `@JSONProperty`
- **스레드 안전**: `Sendable` 준수 자동 추가

## 요구사항

- Swift 6.2+
- macOS 10.15+ / iOS 15+ / tvOS 15+ / watchOS 6+

## 설치

### Swift Package Manager

`Package.swift`에 추가:

```swift
dependencies: [
    .package(url: "https://github.com/dalonng/Bourne.git", from: "0.4.0")
]
```

그런 다음 `Bourne`을 타겟 의존성에 추가:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Bourne"]
)
```

## 사용법

### `@Bourne` 기본 사용법

```swift
import Bourne

@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

이것은 다음을 생성합니다:

- `CodingKeys` 열거형
- 안전한 기본값을 가진 `init(from decoder: Decoder)`
- `encode(to encoder: Encoder)`
- `static let empty` - 기본값을 가진 빈 인스턴스
- `func copy(...)` - 수정된 복사본 생성

### `@BourneEnum`을 사용한 열거형 지원

```swift
@BourneEnum
public enum Gender: String, Sendable {
    case male
    case female
}
```

### `@JSONProperty`를 사용한 사용자 정의 속성 설정

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

매개변수:

- `defaultValue`: JSON 키가 누락된 경우의 사용자 정의 기본값
- `name`: 사용자 정의 JSON 키 이름 (snake_case에서 camelCase로의 매핑용)

### 중첩 모델

```swift
@Bourne
public struct Address {
    public let city: String
    public let street: String
}

@Bourne
public struct PersonWithAddress {
    public let name: String
    public let address: Address  // 누락된 경우 Address.empty 사용
}
```

### Copy 메서드 사용

모델은 기본적으로 불변이므로 `copy()`를 사용하여 수정된 인스턴스를 생성합니다:

```swift
let person = Person(name: "Alice", age: 25, isChild: false)
let updatedPerson = person.copy(age: 26)  // age만 변경
```

## 기본값

JSON 키가 누락된 경우 Bourne은 다음 기본값을 사용합니다:

| 타입 | 기본값 |
|------|--------|
| `String` | `""` |
| `Int` | `0` |
| `Bool` | `false` |
| `Float` / `Double` / `CGFloat` | `0` |
| `Array` | `[]` |
| 사용자 정의 `@Bourne` 타입 | `.empty` |
| 사용자 정의 `@BourneEnum` 타입 | 첫 번째 케이스 (또는 `@JSONProperty`로 사용자 정의) |

## 생성되는 코드 예시

다음 구조체의 경우:

```swift
@Bourne
public struct Person {
    public let name: String
    public let age: Int
    public var isChild: Bool
}
```

Bourne은 다음을 생성합니다:

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

## 라이선스

MIT License
