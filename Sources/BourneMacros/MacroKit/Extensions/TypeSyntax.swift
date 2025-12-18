//
//  TypeSyntax.swift
//
//
//  Created by 大桥 on 2024/6/28.
//

import SwiftSyntax

extension TypeSyntax {
  var isObject: Bool {
    isBasicType == false
  }

  var isBasicType: Bool {
    guard let simpleType = self.as(IdentifierTypeSyntax.self) else {
      return false
    }

    let basicTypes = [
      "Int", "Int8", "Int16", "Int32", "Int64",
      "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
      "Float", "Double",
      "CGFloat",
      "Bool",
      "String",
      "Character",
      "UUID",
    ]

    return basicTypes.contains(simpleType.name.text)
  }

  var isInteger: Bool {
    guard let simpleType = self.as(IdentifierTypeSyntax.self) else {
      return false
    }

    let numbers = [
      "Int", "Int8", "Int16", "Int32", "Int64",
      "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
    ]
    return numbers.contains(simpleType.name.text)
  }

  var isFloat: Bool {
    guard let simpleType = self.as(IdentifierTypeSyntax.self) else {
      return false
    }

    return ["Float", "Double", "CGFloat"].contains(simpleType.name.text)
  }

  var isNumber: Bool {
    isInteger || isFloat
  }

  var isArrayType: Bool {
    if self.as(ArrayTypeSyntax.self) != nil {
      return true
    }

    // 检查是否是 Array<ElementType> 形式
    if let identifierType = self.as(IdentifierTypeSyntax.self), identifierType.genericArgumentClause != nil, identifierType.name.text == "Array" {
      return true
    }

    return false
  }
}
