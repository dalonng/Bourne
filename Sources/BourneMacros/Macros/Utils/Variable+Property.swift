//
//  File.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension Variable {
  var jsonProperty: MacroAttribute? {
    attribute(named: "JSONProperty")?.asMacroAttribute
  }

  var defaultExpr: String {
    if let defaultValueExpr = jsonProperty?.argument(labeled: "defaultValue")?._syntax.description {
      "static let \(name): \(type) = \(defaultValueExpr)"
    } else {
      ""
    }
  }

  var nameExpr: String {
    if let nameExpr = jsonProperty?.argument(labeled: "name")?._syntax.description {
      "static let \(name)Name: String = \(nameExpr)"
    } else {
      ""
    }
  }

  private var coldingKey: String? {
    jsonProperty?.argument(labeled: "name")?._syntax.description
  }

  var coldingKeyExpr: String {
    if let coldingKey {
      "case \(name) = \(coldingKey)"
    } else {
      "case \(name)"
    }
  }

  var jsonValueType: JSONValueType {
    guard let typeAnnotation = _syntax.bindings.first?.typeAnnotation?.type else {
      return .invalid
    }

    if type == "String" {
      return .string
    }

    if typeAnnotation.isInteger {
      return .int
    }

    if typeAnnotation.isFloat {
      return .double
    }

    if typeAnnotation.kind == .arrayType {
      return .array
    }

    if type == "Bool" {
      return .boolean
    }

    if typeAnnotation.kind == .arrayType {
      return .array
    }

    if typeAnnotation.isObject {
      return .object(type)
    }
    return .invalid
  }
}
