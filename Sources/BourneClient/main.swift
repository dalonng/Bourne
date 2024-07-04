import Bourne
import CoreGraphics
import SwiftParser
import SwiftSyntax

@Bourne
struct Person: Codable {
  let name: String
  let age: Int
  var isChild: Bool
}

@Bourne
public struct WholeType: Codable {
  let name: String
  let age: Int
  let isChild: Bool
  let person: Person
  let float: Float
  let cgFloat: CGFloat
  let double: Double
  let int: Int
  let urls: [String]
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
