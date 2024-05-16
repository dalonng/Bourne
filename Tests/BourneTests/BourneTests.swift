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
  func testBourneMacro() throws {
    assertMacroExpansion(<#T##String#>, expandedSource: <#T##String#>, macros: <#T##[String : Macro]#>)
  }

  func testAutoCodable() throws {
    assertMacroExpansion(
      """
      @Bourne
      struct Person: Codable {
        let name: String
        let age: Int
        let isChild: Bool
      }
      """,
      expandedSource: """
      struct Person: Codable {
        let name: String
        let age: Int
        let isChild: Bool
      }
      extension Person {
        enum CodingKeys: String, CodingKey {
          case name
          case age
          case isChild
        }

        init(from decoder: any Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
          self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
          self.isChild = try container.decodeIfPresent(Bool.self, forKey: .isChild) ?? false
        }

        func encode(to encoder: any Encoder) throws {
          var container = encoder.container(keyedBy: CodingKeys.self)
          try container.encode(name, forKey: .name)
          try container.encode(age, forKey: .age)
          try container.encode(isChild, forKey: .isChild)
        }
      }
      """,
      macros: testMacros,
      testModuleName: "BourneMacros",
      indentationWidth: .spaces(2)
    )
  }
}
