//
//  Attribute.swift
//
//
//  Created by 大桥 on 2024/6/27.
//

import SwiftSyntax

public struct Attribute {
  public var _syntax: AttributeSyntax

  init(_syntax: AttributeSyntax) {
    self._syntax = _syntax
  }

  init?(_ syntax: any PatternSyntaxProtocol) {
    guard let syntax = syntax.as(AttributeSyntax.self) else {
      return nil
    }
    _syntax = syntax
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

    fatalError("Variable declaration must have a type")
  }
}
let propertyName = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""
let attributes = property.attributes.compactMap { $0.as(AttributeSyntax.self) }
for attribute in attributes {
  print("attribute: \(attribute):")
  if let attributeName = attribute.attributeName.as(IdentifierTypeSyntax.self) {
    print("\tattributeName: \(attributeName.name.text)")
  }
  if let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) {
    for element in arguments {
      if let label = element.label?.text, let value = element.expression.as(StringLiteralExprSyntax.self)?.segments.first {
        print("\t\tlabel: \(label), value: \(value)")
      }
    }
  }
}
