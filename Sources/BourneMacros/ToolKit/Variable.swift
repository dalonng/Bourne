//
//  Variable.swift
//
//
//  Created by 大桥 on 2024/5/14.
//

import SwiftSyntax

public struct Variable {
  public var _syntax: VariableDeclSyntax

  init(_syntax: VariableDeclSyntax) {
    self._syntax = _syntax
  }

  init?(_ syntax: any DeclSyntaxProtocol) {
    guard let syntax = syntax.as(VariableDeclSyntax.self) else {
      return nil
    }
    _syntax = syntax
  }

  var name: String {
    _syntax.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""
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

    fatalError("Variable declaration must have a type")
  }
}
