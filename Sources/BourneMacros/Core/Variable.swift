//
//  Variable.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

public struct Variable {
  var _syntax: VariableDeclSyntax

  public init(_ _syntax: VariableDeclSyntax) {
    self._syntax = _syntax
  }

  public init?(_ syntax: any DeclSyntaxProtocol) {
    guard let syntax = syntax.as(VariableDeclSyntax.self) else {
      return nil
    }
    _syntax = syntax
  }

  public var attributes: [Attribute] {
    _syntax.attributes.compactMap { attribute in
      switch attribute {
        case .attribute(let attributeSyntax):
          Attribute(attributeSyntax)
        case .ifConfigDecl:
          nil
      }
    }
  }

  var name: String {
    _syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""
  }

  var isLet: Bool {
    _syntax.bindingSpecifier.tokenKind == .keyword(.let)
  }

  var isVar: Bool {
    _syntax.bindingSpecifier.tokenKind == .keyword(.var)
  }

  var isNoInitializer: Bool {
    !isReadOnly && _syntax.bindings.first?.initializer == nil
  }

  var isReadOnly: Bool {
    _syntax.bindings.first?.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self) != nil
  }

  var propertyType: TypeSyntax {
    guard let binding = _syntax.bindings.first else {
      fatalError("Variable declaration must have a binding")
    }
    guard let t = binding.typeAnnotation?.type else {
      fatalError("Variable declaration must have a type")
    }

    return t
  }

  var type: String {
    propertyType.withoutTrival().description
  }

  var defaultValue: String {
    if propertyType.kind == .arrayType {
      return "[]"
    }

    if type == "String" {
      return "\"\""
    }
    if type == "Int" {
      return "0"
    }
    if type == "Bool" {
      return "false"
    }

    if type == "Bool" {
      return "false"
    }

    if !propertyType.isBasicType {
      return "\(type).empty"
    }

    fatalError("Variable declaration must have a type")
  }
}
