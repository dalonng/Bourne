//
//  JSONValue.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

import Foundation

enum JSONValue {
  case string(String)
  case number(Double)
  case boolean(Bool)
  case array([JSONValue])
  case object([String: JSONValue])
  case null
}

enum JSONValueType {
  case string
  case int
  case double
  case decimal
  case boolean
  case array
  case object(String)
  case uuid
  case invalid

  var defaultValueExpr: String {
    switch self {
    case .string: "\"\""
    case .int: "Int.zero"
    case .double: "0.0"
    case .decimal: "Decimal.zero"
    case .boolean: "false"
    case .array: "[]"
    case .object(let type): "\(type).empty"
    case .uuid: "UUID()"
    case .invalid:
      fatalError("invalid case")
    }
  }
}
