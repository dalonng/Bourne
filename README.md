# Bourne
> 通过 Swift 宏方式，实现 JSON 解析。坦率的说，这个库并不是很通用，限定了 `struct` 和 `let`, 数据对象不能修改，只能通过 copy 修改。这会让数据对象在多线程环境下避免很多数据竞争问题。

自动解析JSON，Struct、let



## 例子

```swift
@Bourne
public struct Person: Codable {
  public let name: String
  public let age: Int
  public var isChild: Bool
}

@Bourne
public struct WholeType: Codable {
  public let name: String¢
  public let age: Int
  public let isChild: Bool
  public let person: Person
  public let float: Float
  public let cgFloat: CGFloat
  public let double: Double
  public let int: Int
  public let urls: [String]
}
```

#### 展开之后

````swift
extension Person {
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

extension WholeType {
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case isChild
        case person
        case float
        case cgFloat
        case double
        case int
        case urls
    }
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        self.isChild = try container.decodeIfPresent(Bool.self, forKey: .isChild) ?? false
        self.person = try container.decodeIfPresent(Person.self, forKey: .person) ?? Person.empty
        self.float = try container.decodeIfPresent(Float.self, forKey: .float) ?? 0
        self.cgFloat = try container.decodeIfPresent(CGFloat.self, forKey: .cgFloat) ?? 0
        self.double = try container.decodeIfPresent(Double.self, forKey: .double) ?? 0
        self.int = try container.decodeIfPresent(Int.self, forKey: .int) ?? 0
        self.urls = try container.decodeIfPresent([String].self, forKey: .urls) ?? []
    }
    public func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
      try container.encode(age, forKey: .age)
      try container.encode(isChild, forKey: .isChild)
      try container.encode(person, forKey: .person)
      try container.encode(float, forKey: .float)
      try container.encode(cgFloat, forKey: .cgFloat)
      try container.encode(double, forKey: .double)
      try container.encode(int, forKey: .int)
      try container.encode(urls, forKey: .urls)
    }
     public static let empty = WholeType(
        name: "",
        age: 0,
        isChild: false,
        person: Person.empty,
        float: 0,
        cgFloat: 0,
        double: 0,
        int: 0,
        urls: []
     )
    public func copy(
      name: String? = nil,
      age: Int? = nil,
      isChild: Bool? = nil,
      person: Person? = nil,
      float: Float? = nil,
      cgFloat: CGFloat? = nil,
      double: Double? = nil,
      int: Int? = nil,
      urls: [String]? = nil
    ) -> WholeType {
      WholeType(
        name: name ?? self.name,
        age: age ?? self.age,
        isChild: isChild ?? self.isChild,
        person: person ?? self.person,
        float: float ?? self.float,
        cgFloat: cgFloat ?? self.cgFloat,
        double: double ?? self.double,
        int: int ?? self.int,
        urls: urls ?? self.urls
      )
    }
}
````

