import Bourne
import SwiftParser
import SwiftSyntax

let a = 17
let b = 25

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
}

@Bourne
public struct UserInfo: Codable {
  /// milliseconds
  public let createdAt: Int
  /// milliseconds
  public let updatedAt: Int
  public let did: String
  public let email: String
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

let (result, code) = #stringify(a + b)

let source = """
struct Example {
    let readOnlyLet = 42
  let a
}
"""

func main() {
  let syntaxTree = Parser.parse(source: source)
  let analyzer = VariableAnalyzer(viewMode: .all)
  analyzer.walk(syntaxTree)

//  // Parse the source code in sourceText into a syntax tree
//  let sourceFile: SourceFileSyntax = Parser.parse(source: source)
//
//  // The "description" of the source tree is the source-accurate view of what was parsed.
//  assert(sourceFile.description == source)
//
//  // Visualize the complete syntax tree.
//  dump(sourceFile)
}

main()
