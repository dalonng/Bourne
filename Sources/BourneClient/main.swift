import Bourne
import CoreGraphics
import SwiftParser
import SwiftSyntax

@Bourne
public struct Person: Codable {
  public let name: String
  public let age: Int
  public var isChild: Bool
}

@Bourne
public struct WholeType: Codable {
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
@frozen public struct Picture: Codable {
  public let description: String
  public let urls: Urls
  public let width: Float
//  public let height: Float
  public let blurHash: String
}

@Bourne
@frozen public struct Urls: Codable, Hashable {
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

func main() {
  let syntaxTree = Parser.parse(source: source)
  let analyzer = VariableAnalyzer(viewMode: .all)
  analyzer.walk(syntaxTree)
}

main()
