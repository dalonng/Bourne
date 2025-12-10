//
//  BourneEnumTests.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@testable import BourneMacros

@Suite("BourneEnum Tests")
struct BourneEnumTests {
  let testMacros: [String: any Macro.Type] = [
    "BourneEnum": BourneEnumMacro.self,
  ]

  @Test("Enum with Int raw value generates Codable conformance")
  func testEnumWithIntRawValue() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum Status: Int {
        case active
        case inactive
        case pending
      }
      """,
      expandedSource: """
        public enum Status: Int {
          case active
          case inactive
          case pending

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(Int.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid Status value: \\(rawValue)"
                  )
              }
              self = value
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          public static let defaultValue = Status.active
        }

        extension Status: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Enum with String raw value generates Codable conformance")
  func testEnumWithStringRawValue() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum Color: String {
        case red
        case green
        case blue = "blue_color"
      }
      """,
      expandedSource: """
        public enum Color: String {
          case red
          case green
          case blue = "blue_color"

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(String.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid Color value: \\(rawValue)"
                  )
              }
              self = value
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          public static let defaultValue = Color.red
        }

        extension Color: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Internal enum (no access level)")
  func testInternalEnum() {
    assertMacroExpansion(
      """
      @BourneEnum
      enum Direction: Int {
        case north
        case south
        case east
        case west
      }
      """,
      expandedSource: """
        enum Direction: Int {
          case north
          case south
          case east
          case west

          init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(Int.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid Direction value: \\(rawValue)"
                  )
              }
              self = value
          }

          func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          static let defaultValue = Direction.north
        }

        extension Direction: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Enum without raw value type generates String-based Codable")
  func testEnumWithoutRawValueType() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum SimpleEnum {
        case one
        case two
        case three
      }
      """,
      expandedSource: """
        public enum SimpleEnum {
          case one
          case two
          case three

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(String.self)
              switch rawValue {
              case "one": self = .one
              case "two": self = .two
              case "three": self = .three
              default:
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid SimpleEnum value: \\(rawValue)"
                  )
              }
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .one: try container.encode("one")
            case .two: try container.encode("two")
            case .three: try container.encode("three")
            }
          }

          public static let defaultValue = SimpleEnum.one
        }

        extension SimpleEnum: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Enum with existing Sendable conformance")
  func testEnumWithExistingSendable() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum Priority: String, Sendable {
        case low
        case medium
        case high
      }
      """,
      expandedSource: """
        public enum Priority: String, Sendable {
          case low
          case medium
          case high

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(String.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid Priority value: \\(rawValue)"
                  )
              }
              self = value
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          public static let defaultValue = Priority.low
        }

        extension Priority: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Enum with UInt raw value")
  func testEnumWithUIntRawValue() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum Level: UInt {
        case beginner
        case intermediate
        case advanced
      }
      """,
      expandedSource: """
        public enum Level: UInt {
          case beginner
          case intermediate
          case advanced

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(UInt.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid Level value: \\(rawValue)"
                  )
              }
              self = value
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          public static let defaultValue = Level.beginner
        }

        extension Level: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }

  @Test("Enum with Int8 raw value")
  func testEnumWithInt8RawValue() {
    assertMacroExpansion(
      """
      @BourneEnum
      public enum SmallNumber: Int8 {
        case one
        case two
      }
      """,
      expandedSource: """
        public enum SmallNumber: Int8 {
          case one
          case two

          public init(from decoder: any Decoder) throws {
              let container = try decoder.singleValueContainer()
              let rawValue = try container.decode(Int8.self)
              guard let value = Self(rawValue: rawValue) else {
                  throw DecodingError.dataCorruptedError(
                      in: container,
                      debugDescription: "Invalid SmallNumber value: \\(rawValue)"
                  )
              }
              self = value
          }

          public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue)
          }

          public static let defaultValue = SmallNumber.one
        }

        extension SmallNumber: Decodable, Encodable, Sendable {
        }
        """,
      macros: testMacros
    )
  }
}
