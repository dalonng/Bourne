import Bourne
import CoreGraphics
import Foundation

@Bourne
public struct Person {
  public let name: String

  @JSONProperty(defaultValue: 1, name: "Age")
  public let age: Int
  @JSONProperty(defaultValue: false, name: "is_child")
  public var isChild: Bool

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender

  @JSONProperty(defaultValue: TestEnum.one)
  public let testEnum: TestEnum

  @JSONProperty(defaultValue: TestEnum2.red)
  public let testEnum2: TestEnum2
}

@BourneEnum
public enum TestEnum: Int {
  case one
  case two
  case three
}

@BourneEnum
public enum TestEnum2: String, Sendable {
  case red
  case green
  case blue = "blue_color"
}

@Bourne
public struct WholeType {
  public let name: String
  public let age: Int
  public let isChild: Bool
  public let person: Person
  public let float: Float
  public let cgFloat: CGFloat
  public let double: Double
  public let int: Int
  public let urls: [String]
}

@Bourne
@frozen public struct Picture {
  public let description: String
  public let urls: Urls
  public let width: Float
  //  public let height: Float
  public let blurHash: String
}

@Bourne
@frozen public struct Urls: Hashable {
  public let raw: String
  public let full: String
  public let regular: String
  public let small: String
  public let thumb: String
}

let source = """
public struct Person2: Codable {
  let person: Person
}
"""

public enum Gender: String, Sendable, Codable {
  case male = "fdsfds"
  case female
}

@Bourne
public struct Person2 {
  @JSONProperty(defaultValue: UUID(uuid: uuid_t(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)))
  public let id: UUID

  public let name: String

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender

  @JSONProperty(defaultValue: TestEnum.one)
  public let testEnum: TestEnum

  @JSONProperty(defaultValue: TestEnum2.red)
  public let testEnum2: TestEnum2
}

func main() {
  let person = Person2(
    id: UUID(),
    name: "张三",
    gender: .male,
    testEnum: .two,
    testEnum2: .blue,
  )
  let encoder = JSONEncoder()
  do {
    let jsonData = try encoder.encode(person)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      print(jsonString)
    }
    let persion = try JSONDecoder().decode(Person2.self, from: jsonData)
    print("解码成功: \(persion)")
  } catch {
    print("编码失败: \(error)")
  }

  //  let syntaxTree = Parser.parse(source: source)
  //  let analyzer = VariableAnalyzer(viewMode: .all)
  //  analyzer.walk(syntaxTree)

  //  @JSONProperty(defaultValue: PersonType.child, name: "person_ype")
  //  public let personType: PersonType
}

extension Person {
  public enum PersonType {
    case child
    case boy
    case girl
  }
}

main()
