//
//  BourneMacro.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct BourneMacro: MemberMacro, ExtensionMacro {
  // MARK: - MemberMacro

  public static func expansion(
    of _: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in _: some MacroExpansionContext,
  ) throws -> [DeclSyntax] {
    let declGroup = DeclGroup(declaration)

    #if DEBUG
    print("Expanding @Bourne(member) for declaration: \(declaration)")
    print("Missing conformances (member side): \(protocols)")
    #endif

    guard case .struct(let structDecl) = declGroup else {
      throw MacroError("@Bourne can only be applied to structs")
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

  // MARK: - ExtensionMacro

  public static func expansion(
    of _: AttributeSyntax,
    attachedTo _: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in _: some MacroExpansionContext,
  ) throws -> [ExtensionDeclSyntax] {
    guard !protocols.isEmpty else {
      return []
    }

    #if DEBUG
    print("Expanding @Bourne(extension) for type: \(type)")
    print("Protocols to add on extension: \(protocols)")
    #endif

    let protoList = protocols
      .map(\.trimmed.description)
      .joined(separator: ", ")

    let ext = try ExtensionDeclSyntax(
      "extension \(type.trimmed): \(raw: protoList) {}",
    )

    return [ext]
  }
}
