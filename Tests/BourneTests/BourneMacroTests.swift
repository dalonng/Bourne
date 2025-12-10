//
//  BourneMacroTests.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@testable import BourneMacros

@Suite("BourneMacro Tests - Struct Parsing")
struct BourneMacroTests {
  let testMacros: [String: any Macro.Type] = [
    "Bourne": BourneMacro.self,
    "JSONProperty": JSONPropertyMacro.self,
  ]

  @Test("Simple struct generates CodingKeys and Codable conformance")
  func testSimpleStruct() {
    assertMacroExpansion(
      """
      @Bourne
      public struct Person {
        public let name: String
        public let age: Int
      }
      """,
      expandedSource: """
        public struct Person {
          public let name: String
          public let age: Int

          public init(name: String, age: Int) {
            self.name = name
            self.age = age
          }

          enum CodingKeys: String, CodingKey {
              case name
              case age
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
              self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(age, forKey: .age)
          }

          public static let empty = Person(
            name: "",
            age: 0
          )

          public func copy(
            name: String? = nil,
            age: Int? = nil
          ) -> Person {
            Person(
              name: name ?? self.name,
              age: age ?? self.age
            )
          }
        }

        extension Person: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Struct with JSONProperty for custom key name")
  func testStructWithJSONPropertyCustomKey() {
    assertMacroExpansion(
      """
      @Bourne
      public struct User {
        public let name: String
        @JSONProperty(name: "user_age")
        public let age: Int
      }
      """,
      expandedSource: """
        public struct User {
          public let name: String
          public let age: Int

          static let ageName: String = "user_age"

          public init(name: String, age: Int) {
            self.name = name
            self.age = age
          }

          enum CodingKeys: String, CodingKey {
              case name
              case age = "user_age"
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
              self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? 0
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(age, forKey: .age)
          }

          public static let empty = User(
            name: "",
            age: 0
          )

          public func copy(
            name: String? = nil,
            age: Int? = nil
          ) -> User {
            User(
              name: name ?? self.name,
              age: age ?? self.age
            )
          }
        }

        extension User: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Struct with JSONProperty for default value")
  func testStructWithJSONPropertyDefaultValue() {
    assertMacroExpansion(
      """
      @Bourne
      public struct Config {
        public let name: String
        @JSONProperty(defaultValue: true)
        public let enabled: Bool
      }
      """,
      expandedSource: """
        public struct Config {
          public let name: String
          public let enabled: Bool

          static let enabled: Bool = true

          public init(name: String, enabled: Bool) {
            self.name = name
            self.enabled = enabled
          }

          enum CodingKeys: String, CodingKey {
              case name
              case enabled
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
              self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? Self.enabled
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(enabled, forKey: .enabled)
          }

          public static let empty = Config(
            name: "",
            enabled: Self.enabled
          )

          public func copy(
            name: String? = nil,
            enabled: Bool? = nil
          ) -> Config {
            Config(
              name: name ?? self.name,
              enabled: enabled ?? self.enabled
            )
          }
        }

        extension Config: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Struct with multiple types (String, Int, Bool, Float, Double)")
  func testStructWithMultipleTypes() {
    assertMacroExpansion(
      """
      @Bourne
      public struct MultiType {
        public let name: String
        public let count: Int
        public let enabled: Bool
        public let price: Float
        public let rate: Double
      }
      """,
      expandedSource: """
        public struct MultiType {
          public let name: String
          public let count: Int
          public let enabled: Bool
          public let price: Float
          public let rate: Double

          public init(name: String, count: Int, enabled: Bool, price: Float, rate: Double) {
            self.name = name
            self.count = count
            self.enabled = enabled
            self.price = price
            self.rate = rate
          }

          enum CodingKeys: String, CodingKey {
              case name
              case count
              case enabled
              case price
              case rate
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
              self.count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
              self.enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? false
              self.price = try container.decodeIfPresent(Float.self, forKey: .price) ?? 0
              self.rate = try container.decodeIfPresent(Double.self, forKey: .rate) ?? 0
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(count, forKey: .count)
            try container.encode(enabled, forKey: .enabled)
            try container.encode(price, forKey: .price)
            try container.encode(rate, forKey: .rate)
          }

          public static let empty = MultiType(
            name: "",
            count: 0,
            enabled: false,
            price: 0,
            rate: 0
          )

          public func copy(
            name: String? = nil,
            count: Int? = nil,
            enabled: Bool? = nil,
            price: Float? = nil,
            rate: Double? = nil
          ) -> MultiType {
            MultiType(
              name: name ?? self.name,
              count: count ?? self.count,
              enabled: enabled ?? self.enabled,
              price: price ?? self.price,
              rate: rate ?? self.rate
            )
          }
        }

        extension MultiType: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Struct with array type")
  func testStructWithArrayType() {
    assertMacroExpansion(
      """
      @Bourne
      public struct Collection {
        public let items: [String]
      }
      """,
      expandedSource: """
        public struct Collection {
          public let items: [String]

          public init(items: [String]) {
            self.items = items
          }

          enum CodingKeys: String, CodingKey {
              case items
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.items = try container.decodeIfPresent([String].self, forKey: .items) ?? []
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(items, forKey: .items)
          }

          public static let empty = Collection(
            items: []
          )

          public func copy(
            items: [String]? = nil
          ) -> Collection {
            Collection(
              items: items ?? self.items
            )
          }
        }

        extension Collection: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Internal struct (no access level)")
  func testInternalStruct() {
    assertMacroExpansion(
      """
      @Bourne
      struct InternalModel {
        let name: String
      }
      """,
      expandedSource: """
        struct InternalModel {
          let name: String

          init(name: String) {
            self.name = name
          }

          enum CodingKeys: String, CodingKey {
              case name
          }

          init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
          }

          func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
          }

          static let empty = InternalModel(
            name: ""
          )

          func copy(
            name: String? = nil
          ) -> InternalModel {
            InternalModel(
              name: name ?? self.name
            )
          }
        }

        extension InternalModel: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Struct with nested object type")
  func testStructWithNestedObjectType() {
    assertMacroExpansion(
      """
      @Bourne
      public struct Container {
        public let child: ChildObject
      }
      """,
      expandedSource: """
        public struct Container {
          public let child: ChildObject

          public init(child: ChildObject) {
            self.child = child
          }

          enum CodingKeys: String, CodingKey {
              case child
          }

          public init(from decoder: any Decoder) throws {
              let container = try decoder.container(keyedBy: CodingKeys.self)
              self.child = try container.decodeIfPresent(ChildObject.self, forKey: .child) ?? ChildObject.empty
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(child, forKey: .child)
          }

          public static let empty = Container(
            child: ChildObject.empty
          )

          public func copy(
            child: ChildObject? = nil
          ) -> Container {
            Container(
              child: child ?? self.child
            )
          }
        }

        extension Container: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }
}
