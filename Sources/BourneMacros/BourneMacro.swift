//
//  BourneMacro.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

public struct BourneMacro: ExtensionMacro {
  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
    conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
    let decl = DeclGroup(declaration)

    guard let structDecl = decl.asStruct else {
      throw BourneMacroError.mustBeStruct
    }

    let variables = structDecl.variables.filter(\.isNoInitializer)
    let extensionDecl = try ExtensionDeclSyntax("extension \(type)") {
      generateCodingKeys(properties: variables)
      DeclSyntax("\n")
      try generateInitializer(properties: variables, structDecl: structDecl)
      DeclSyntax("\n")
      try generateEncoder(properties: variables, structDecl: structDecl)
      DeclSyntax("\n")
      try generateEmpty(properties: variables, structDecl: structDecl)
      DeclSyntax("\n")
      try generateCopy(properties: variables, structDecl: structDecl)
    }

    return [extensionDecl]
  }

  private static func generateCodingKeys(properties: [Variable]) -> DeclSyntax {
    let caseDeclarations = properties.map { p in
      if let attribute = p.attributes.first(where: { $0.name == "JSONProperty" }),
         let name = attribute.argument(labeled: "name")
      {
        "case \(p.name) = \(name)"
      } else {
        "case \(p.name)"
      }
    }.joined(separator: "\n")
    return DeclSyntax("""
    enum CodingKeys: String, CodingKey {
        \(raw: caseDeclarations)
    }
    """)
  }

  private static func generateInitializer(properties: [Variable], structDecl: Struct) throws -> DeclSyntax {
    let decodingStatements = properties.map { p in
      if let attribute = p.attributes.first(where: { $0.name == "JSONProperty" }), attribute.argument(labeled: "defaultValue") != nil {
        "self.\(p.name) = try container.decodeIfPresent(\(p.type).self, forKey: .\(p.name)) ?? \(structDecl.identifier).\(p.name)"
      } else {
        "self.\(p.name) = try container.decodeIfPresent(\(p.type).self, forKey: .\(p.name)) ?? \(p.defaultValue)"
      }
    }.joined(separator: "\n")
    return DeclSyntax("""
    \(raw: structDecl.accessLevel.rawValue) init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        \(raw: decodingStatements)
    }
    """)
  }

  private static func generateEncoder(properties: [Variable], structDecl: Struct) throws -> DeclSyntax {
    let encodeStatements = properties.map { v in
      "try container.encode(\(v.name), forKey: .\(v.name))"
    }.joined(separator: "\n")

    return DeclSyntax("""
    \(raw: structDecl.accessLevel.rawValue) func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
        \(raw: encodeStatements)
    }
    """)
  }

  private static func generateEmpty(properties: [Variable], structDecl: Struct) throws -> DeclSyntax {
    let _properties = properties.map { p in
      if let attribute = p.attributes.first(where: { $0.name == "JSONProperty" }), attribute.argument(labeled: "defaultValue") != nil {
        "\(p.name): \(structDecl.identifier).\(p.name)"
      } else {
        "\(p.name): \(p.defaultValue)"
      }
    }.joined(separator: ",\n")
    return DeclSyntax("""
     \(raw: structDecl.accessLevel.rawValue) static let empty = \(raw: structDecl.identifier)(
        \(raw: _properties)
     )
    """)
  }

  private static func generateCopy(properties: [Variable], structDecl: Struct) throws -> DeclSyntax {
    let paramters = properties.map { p in
      "\(p.name): \(p.type)? = nil"
    }.joined(separator: ",\n")

    let setParamters = properties.map { p in
      "\(p.name): \(p.name) ?? self.\(p.name)"
    }.joined(separator: ",\n")

    return DeclSyntax("""
    \(raw: structDecl.accessLevel.rawValue) func copy(
      \(raw: paramters)
    ) -> \(raw: structDecl.identifier) {
      \(raw: structDecl.identifier)(
        \(raw: setParamters)
      )
    }
    """)
  }
}

extension [Variable] {
  var names: [String] {
    map(\.name)
  }
}

enum BourneMacroError: Error {
  case mustBeStruct
}
