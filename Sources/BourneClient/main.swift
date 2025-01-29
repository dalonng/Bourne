import Bourne
import CoreGraphics
import Foundation
import MacroToolkit
import SwiftParser
import SwiftSyntax

@Bourne
public struct Person {
  public let name: String

  @JSONProperty(defaultValue: 1, name: "Age")
  public let age: Int
  @JSONProperty(defaultValue: false, name: "is_child")
  public var isChild: Bool

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender
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
  public let name: String

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender
}

func main() {
  let person = Person2(name: "张三", gender: .male)
  let encoder = JSONEncoder()
  do {
    let jsonData = try encoder.encode(person)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
      print(jsonString)
    }
    let p = try JSONDecoder().decode(Person2.self, from: jsonData)
    print("解码成功: \(p)")
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
