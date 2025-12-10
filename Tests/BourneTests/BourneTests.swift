import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@testable import BourneMacros

@Test func decodePerssion() throws {
  let person: Person = try """
  {
    "name": "张三",
    "age": 25,
    "isChild": false,
    "gender": "male"
  }
  """.forceDecode()

  #expect(person.name == "张三")
  #expect(person.age == 25)
  #expect(person.isChild == false)
  #expect(person.gender == .male)
}
