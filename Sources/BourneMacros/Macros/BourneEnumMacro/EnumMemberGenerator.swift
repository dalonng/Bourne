//
//  EnumMemberGenerator.swift
//  BourneMacros
//
//  Created by d on 2025/03/11.
//

import SwiftSyntax
import SwiftSyntaxBuilder

struct EnumMemberGenerator {
  let enumDecl: Enum

  func generate() throws -> [DeclSyntax] {
    guard let firstCase = enumDecl.cases.first else {
      throw MacroError("@Bourne enums must declare at least one case")
    }

    let members: [DeclSyntax]
    if let rawTypeName = rawValueTypeName {
      members = [
        generateRawValueDecoder(rawType: rawTypeName),
        generateRawValueEncoder(),
        generateEmpty(firstCase: firstCase.identifier),
      ]
    } else {
      let caseInfos = try parseCaseInfos()
      members = [
        generateStringDecoder(caseInfos: caseInfos),
        generateStringEncoder(caseInfos: caseInfos),
        generateEmpty(firstCase: firstCase.identifier),
      ]
    }

    return members
  }

  private var accessPrefix: String {
    if let accessLevel = enumDecl.accessLevel?.name {
      return "\(accessLevel) "
    }
    return ""
  }

  private var rawValueTypeName: String? {
    guard let firstInheritedType = enumDecl.inheritedTypes.first?.normalizedDescription else {
      return nil
    }

    if EnumValueSupport.supportedRawTypes.contains(firstInheritedType) {
      return firstInheritedType
    }

    return nil
  }

  private func generateRawValueDecoder(rawType: String) -> DeclSyntax {
    DeclSyntax("""
    \(raw: accessPrefix)init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(\(raw: rawType).self)
        guard let value = Self(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid \(raw: enumDecl.identifier) value: \\(rawValue)"
            )
        }
        self = value
    }
    """)
  }

  private func generateRawValueEncoder() -> DeclSyntax {
    DeclSyntax("""
    \(raw: accessPrefix)func encode(to encoder: any Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(self.rawValue)
    }
    """)
  }

  private func generateEmpty(firstCase: String) -> DeclSyntax {
    DeclSyntax("""
    \(raw: accessPrefix)static let empty = \(raw: enumDecl.identifier).\(raw: firstCase)
    """)
  }

  private func parseCaseInfos() throws -> [EnumCaseInfo] {
    try enumDecl.cases.map { enumCase in
      if let value = enumCase.value {
        switch value {
        case .associatedValue:
          throw MacroError("@Bourne enums with associated values are not supported")
        case .rawValue:
          throw MacroError("@Bourne enums without raw value types cannot specify explicit raw values")
        }
      }

      return EnumCaseInfo(
        name: enumCase.identifier,
        literal: StringLiteralExprSyntax(content: enumCase.identifier).description,
      )
    }
  }

  private func generateStringDecoder(caseInfos: [EnumCaseInfo]) -> DeclSyntax {
    let cases = caseInfos
      .map { info in
        "case \(info.literal): self = .\(info.name)"
      }
      .joined(separator: "\n        ")

    return DeclSyntax("""
    \(raw: accessPrefix)init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        \(raw: cases)
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid \(raw: enumDecl.identifier) value: \\(rawValue)"
            )
        }
    }
    """)
  }

  private func generateStringEncoder(caseInfos: [EnumCaseInfo]) -> DeclSyntax {
    let cases = caseInfos
      .map { info in
        "case .\(info.name): try container.encode(\(info.literal))"
      }
      .joined(separator: "\n      ")

    return DeclSyntax("""
    \(raw: accessPrefix)func encode(to encoder: any Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      \(raw: cases)
      }
    }
    """)
  }
}

private struct EnumCaseInfo {
  let name: String
  let literal: String
}

private enum EnumValueSupport {
  static let supportedRawTypes: Set<String> = [
    "String",
    "Character",
    "Int", "Int8", "Int16", "Int32", "Int64",
    "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
  ]
}
