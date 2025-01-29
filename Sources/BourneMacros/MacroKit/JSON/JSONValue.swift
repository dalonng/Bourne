//
//  JSONValue.swift
//  Bourne
//
//  Created by d on 2025/01/28.
//

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
  case boolean
  case array
  case object(String)
  case invalid

  var defaultValueExpr: String {
    switch self {
    case .string: "\"\""
    case .int: "0"
    case .double: "0.0"
    case .boolean: "false"
    case .array: "[]"
    case .object(let type): "\(type).empty"
    case .invalid:
      fatalError("invalid case")
    }
  }
}
