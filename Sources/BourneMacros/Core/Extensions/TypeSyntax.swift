//
//  TypeSyntax.swift
//
//
//  Created by 大桥 on 2024/6/28.
//

import SwiftSyntax

extension TypeSyntax {
  var isBasicType: Bool {
    guard let simpleType = self.as(IdentifierTypeSyntax.self) else {
      return false
    }

    let basicTypes = [
      "Int", "Int8", "Int16", "Int32", "Int64",
      "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
      "Float", "Double",
      "Bool",
      "String",
      "Character"
    ]

    return basicTypes.contains(simpleType.name.text)
  }

  var isArrayType: Bool {
    if self.as(ArrayTypeSyntax.self) != nil {
      return true
    }

    // 检查是否是 Array<ElementType> 形式
    if let identifierType = self.as(IdentifierTypeSyntax.self),
       identifierType.genericArgumentClause != nil,
       identifierType.name.text == "Array"
    {
      return true
    }

    return false
  }

  var arrayElementType: TypeSyntax? {
    if let arrayType = self.as(ArrayTypeSyntax.self) {
      return arrayType.element
    }

    if let identifierType = self.as(IdentifierTypeSyntax.self),
       let genericArguments = identifierType.genericArgumentClause?.arguments,
       identifierType.name.text == "Array",
       genericArguments.count == 1
    {
      return genericArguments.first?.argument
    }

    return nil
  }
}
