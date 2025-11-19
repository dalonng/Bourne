//
//  CodingKeysUtil.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftSyntax

enum CodingKeysUtil {
  static func generateCodingKeys(variables: [Variable]) -> DeclSyntax {
    DeclSyntax("""
    enum CodingKeys: String, CodingKey {
        \(raw: variables.map(\.coldingKeyExpr).joined(separator: "\n"))
    }
    """)
  }

  static func generateDecoder(structDecl: Struct) -> DeclSyntax {
    let decodingStatements = structDecl.storedVariables.map { variable in
      if variable.defaultExpr.isEmpty == false {
        "self.\(variable.name) = try container.decodeIfPresent(\(variable.type).self, forKey: .\(variable.name)) ?? Self.\(variable.name)"
      } else {
        "self.\(variable.name) = try container.decodeIfPresent(\(variable.type).self, forKey: .\(variable.name)) ?? \(variable.jsonValueType.defaultValueExpr)"
      }
    }.joined(separator: "\n")

    let funcExpr = if let accessLevel = structDecl.accessLevel?.name {
      "\(accessLevel) init(from decoder: any Decoder) throws {"
    } else {
      "init(from decoder: any Decoder) throws {"
    }

    return DeclSyntax("""
    \(raw: funcExpr)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(raw: decodingStatements)
    }
    """)
  }

  static func generateEncoder(structDecl: Struct) -> DeclSyntax {
    let encodeStatements = structDecl.storedVariables.map { v in
      "try container.encode(\(v.name), forKey: .\(v.name))"
    }.joined(separator: "\n")

    let funcExpr = if let accessLevel = structDecl.accessLevel?.name {
      "\(accessLevel) func encode(to encoder: any Encoder) throws {"
    } else {
      "func encode(to encoder: any Encoder) throws {"
    }

    return DeclSyntax("""
    \(raw: funcExpr)
      var container = encoder.container(keyedBy: CodingKeys.self)
      \(raw: encodeStatements)
    }
    """)
  }

  static func generateEmpty(structDecl: Struct) -> DeclSyntax {
    let properties = structDecl.storedVariables.map { variable in
      if variable.defaultExpr.isEmpty == false {
        "\(variable.name): Self.\(variable.name)"
      } else {
        "\(variable.name): \(variable.jsonValueType.defaultValueExpr)"
      }
    }.joined(separator: ",\n")

    let emptyExpr = if let accessLevel = structDecl.accessLevel?.name {
      "\(accessLevel) static let empty = \(structDecl.identifier)("
    } else {
      "static let empty = \(structDecl.identifier)("
    }

    return DeclSyntax("""
      \(raw: emptyExpr)
      \(raw: properties)
    )
    """)
  }

  static func generateCopy(structDecl: Struct) -> DeclSyntax {
    let paramters = structDecl.storedVariables.map { variable in
      "\(variable.name): \(variable.type)? = nil"
    }.joined(separator: ",\n")

    let setParamters = structDecl.storedVariables.map { variable in
      "\(variable.name): \(variable.name) ?? self.\(variable.name)"
    }.joined(separator: ",\n")

    let copyFuncExpr = if let accessLevel = structDecl.accessLevel?.name {
      "\(accessLevel) func copy("
    } else {
      "func copy("
    }

    return DeclSyntax("""
    \(raw: copyFuncExpr)
      \(raw: paramters)
    ) -> \(raw: structDecl.identifier) {
      \(raw: structDecl.identifier)(
        \(raw: setParamters)
      )
    }
    """)
  }
}
