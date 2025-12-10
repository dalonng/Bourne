//
//  JSONPropertyTests.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@testable import BourneMacros

@Suite("JSONProperty Tests")
struct JSONPropertyTests {
  let testMacros: [String: any Macro.Type] = [
    "JSONProperty": JSONPropertyMacro.self,
  ]

  @Test("JSONProperty with defaultValue and name generates static properties")
  func testJSONPropertyWithDefaultValueAndName() {
    assertMacroExpansion(
      """
      @JSONProperty(defaultValue: 1, name: "Age")
      public let age: Int
      """,
      expandedSource: """
        public let age: Int

        static let age: Int = 1
        static let ageName: String = "Age"
        """,
      macros: testMacros
    )
  }

  @Test("JSONProperty with only defaultValue generates static property")
  func testJSONPropertyWithOnlyDefaultValue() {
    assertMacroExpansion(
      """
      @JSONProperty(defaultValue: false)
      public var isChild: Bool
      """,
      expandedSource: """
        public var isChild: Bool

        static let isChild: Bool = false

        """,
      macros: testMacros
    )
  }

  @Test("JSONProperty with only name generates static property")
  func testJSONPropertyWithOnlyName() {
    assertMacroExpansion(
      """
      @JSONProperty(name: "user_name")
      public let userName: String
      """,
      expandedSource: """
        public let userName: String

        static let userNameName: String = "user_name"
        """,
      macros: testMacros
    )
  }

  @Test("JSONProperty with enum defaultValue")
  func testJSONPropertyWithEnumDefaultValue() {
    assertMacroExpansion(
      """
      @JSONProperty(defaultValue: Gender.male)
      public let gender: Gender
      """,
      expandedSource: """
        public let gender: Gender

        static let gender: Gender = Gender.male

        """,
      macros: testMacros
    )
  }

  @Test("JSONProperty with defaultValue, name and enum")
  func testJSONPropertyWithDefaultValueNameAndEnum() {
    assertMacroExpansion(
      """
      @JSONProperty(defaultValue: TestEnum.one, name: "test_enum")
      public let testEnum: TestEnum
      """,
      expandedSource: """
        public let testEnum: TestEnum

        static let testEnum: TestEnum = TestEnum.one
        static let testEnumName: String = "test_enum"
        """,
      macros: testMacros
    )
  }
}
