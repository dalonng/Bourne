//
//  MacroError.swift
//  Bourne
//
//  Created by d on 2025/01/29.
//

import SwiftSyntax

enum MacroError: Error, CustomStringConvertible {
  case notAStruct(DeclGroupSyntax)
  case invalidProperties([String])
  case missingRequiredProperty(String)
  case unsupportedType(String)

  public var description: String {
    switch self {
    case .notAStruct(let declaration):
      """
      @Bourne 只能用于 struct 类型
      当前声明: \(declaration)
      """
    case .invalidProperties(let properties):
      "发现无效的属性: \(properties.joined(separator: ", "))"
    case .missingRequiredProperty(let property):
      "缺少必需的属性: \(property)"
    case .unsupportedType(let type):
      "不支持的类型: \(type)"
    }
  }
}
