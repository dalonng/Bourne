//
//  BourneMacro.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import Foundation
import MacroToolkit
import SwiftSyntax
import SwiftSyntaxMacros

// public struct BourneMacro: ExtensionMacro {
//  public static func expansion(
//    of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
//    conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext
//  ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
//    let declGroup = DeclGroup(declaration)
//
//    guard case .struct(let structDecl) = declGroup else {
//      throw MacroError.notAStruct(declaration)
//    }
//
//    let variables = structDecl.codableVariables
//    let extensionDecl = try ExtensionDeclSyntax("extension \(type)") {
//      CodingKeysUtil.generateCodingKeys(variables: variables)
//      CodingKeysUtil.generateDecoder(structDecl: structDecl)
//      CodingKeysUtil.generateEncoder(structDecl: structDecl)
//      CodingKeysUtil.generateEmpty(structDecl: structDecl)
//      CodingKeysUtil.generateCopy(structDecl: structDecl)
//    }
//
//    return [extensionDecl]
//  }
// }

public struct BourneMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let declGroup = DeclGroup(declaration)

    guard case .struct(let structDecl) = declGroup else {
      throw MacroError.notAStruct(declaration)
    }

    return [
      InitDecl(structDecl: structDecl).generate(),
      CodingKeysUtil.generateCodingKeys(variables: structDecl.variables),
      CodingKeysUtil.generateDecoder(structDecl: structDecl),
      CodingKeysUtil.generateEncoder(structDecl: structDecl),
      CodingKeysUtil.generateEmpty(structDecl: structDecl),
      CodingKeysUtil.generateCopy(structDecl: structDecl),
    ]
  }
}
