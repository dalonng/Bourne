import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(BourneMacros)
import BourneMacros

let testMacros: [String: Macro.Type] = [
  "AutoCodableMacro": AutoCodableMacro.self,
]
#endif

final class BourneTests: XCTestCase {
  func testAutoCodable() throws {
    assertMacroExpansion(
      """
      @AutoCodable
      struct Person: Codable {
        let name: String
        let age: Int
      }
      """,
      expandedSource: """
      struct Person: Codable {
        let name: String
        let age: Int
        enum CodingKeys: String, CodingKey {
          case name
          case age
        }

        public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
          name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
          age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
        }

        public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(name, forKey: .name)
          try container.encode(age, forKey: .age)
        }
      }
      """,
      macros: testMacros,
      testModuleName: "BourneMacros",
      indentationWidth: .spaces(2)
    )
  }
}
