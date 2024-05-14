//
//  AutoCodableMacro.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoCodableMacro: MemberMacro {
  public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw AutoCodableMacroError.missingStructDeclaration
    }

//    let structName = structDecl.name.text
    var autoCodableDeclSyntaxs: [String] = []
    try autoCodableDeclSyntaxs.append(generateCodingKeys(structDecl))
    return [DeclSyntax(stringLiteral: autoCodableDeclSyntaxs.joined(separator: "\n"))]
  }

  static func generateCodingKeys(_ structDecl: StructDeclSyntax) throws -> String {
    var codingKeys = ["\n", "enum CodingKeys: String, CodingKey {"]
    var decoder = ["public init(from decoder: any Decoder) throws {"]
    decoder.append("let container = try decoder.container(keyedBy: CodingKeys.self)")
    var encoder = ["public func encode(to encoder: any Encoder) throws {"]
    encoder.append("var container = encoder.container(keyedBy: CodingKeys.self)")

    for member in structDecl.memberBlock.members {
      guard let variableDecl = member.decl.as(VariableDeclSyntax.self) else {
        continue
      }
      guard case let .keyword(key) = variableDecl.bindingSpecifier.tokenKind, key == Keyword.let else {
        throw AutoCodableMacroError.missingLetKeyword
      }

      for binding in variableDecl.bindings {
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
          continue
        }
        guard let type = binding.typeAnnotation?.type else {
          continue
        }

        let typeName = type.description.trimmingCharacters(in: .whitespacesAndNewlines)
        let propertyName = identifier.identifier.text
        let defaultValue = try defaultValue(propertyType: type)

        codingKeys.append("  case \(propertyName)")
        decoder.append("  \(propertyName) = try container.decodeIfPresent(\(typeName).self, forKey: .\(propertyName)) ?? \(defaultValue)")
        encoder.append("  try container.encode(\(propertyName), forKey: .\(propertyName))")
      }
    }

    codingKeys.append("}\n")
    decoder.append("}\n")
    encoder.append("}\n")

    return codingKeys.joined(separator: "\n") + ["\n"] + decoder.joined(separator: "\n") + ["\n"] + encoder.joined(separator: "\n")
  }

  static func defaultValue(propertyType: TypeSyntax) throws -> String {
    if propertyType.kind == .arrayType {
      return "[]"
    }

    let typeName = propertyType.description.trimmingCharacters(in: .whitespacesAndNewlines)
    if typeName == "String" {
      return "\"\""
    }
    if typeName == "Int" {
      return "0"
    }
    if typeName == "Bool" {
      return "false"
    }

    if propertyType == "Bool" {
      return "false"
    }

    throw AutoCodableMacroError.unsupportedType
  }
}

enum AutoCodableMacroError: Error {
  case missingStructDeclaration
  case missingLetKeyword
  case unsupportedType
}
