import Bourne
import SwiftParser
import SwiftSyntax

@Bourne
struct Person: Codable {
  let name: String
  let age: Int
  var isChild: Bool
}

@Bourne
public struct Person2: Codable {
  let name: String
  let age: Int
  let isChild: Bool
  let person: Person
}

@Bourne
public struct UserInfo: Codable {
  /// milliseconds
  public let createdAt: Int
  /// milliseconds
  public let updatedAt: Int
  @JSONProperty(name: "did_dfsfsd")
  public let did: String
  @JSONProperty(defaultValue: "BUZZ", name: "emailName")
  public let email: String

  @JSONProperty(defaultValue: -1)
  public let ipublicd: Int
  public let isNew: Int

  /// milliseconds
  public let membershipExpDate: Int

  /// milliseconds
  public let membershipStartDate: Int
  public let membershipId: Int
  public let picture: String
  public let roles: String
  public let username: String
  public let uid: String
  public let parsedRoles: [String]

  public var isFreeTrail: Bool {
    membershipId == 0
  }
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
