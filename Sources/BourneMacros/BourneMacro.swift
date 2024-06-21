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
    let decodeStatements = variables.map { v in
      "self.\(v.name) = try container.decodeIfPresent(\(v.type).self, forKey: .\(v.name)) ?? \(v.defaultValue)"
    }

    let encodeStatements = variables.map { v in
      "try container.encode(\(v.name), forKey: .\(v.name))"
    }

    let cases = variables.names.map { "case \($0)" }.joined(separator: "\n")

    let properties = variables.map { "\($0.name): \($0.defaultValue)" }.joined(separator: ",\n")

    return try [
      ExtensionDeclSyntax(
        """
        extension \(type.trimmed) {
          enum CodingKeys: String, CodingKey {
            \(raw: cases)
          }

          \(raw: structDecl.accessLevel.rawValue) init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            \(raw: decodeStatements.joined(separator: "\n"))
          }

          \(raw: structDecl.accessLevel.rawValue) func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            \(raw: encodeStatements.joined(separator: "\n"))
          }

          \(raw: structDecl.accessLevel.rawValue) static let empty = \(type.trimmed)(
            \(raw: properties)
          )
        }
        """
      )
    ]
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
