//
//  JsonMock.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

import Foundation

// MARK: - Person JSON Mocks

enum PersonJsonMock {
  /// Complete person with all fields
  static let complete = """
  {
    "name": "ZhangSan",
    "age": 25,
    "isChild": false,
    "gender": "male"
  }
  """

  /// Person with minimal fields (empty JSON)
  static let empty = """
  {}
  """

  /// Person with only name
  static let nameOnly = """
  {
    "name": "LiSi"
  }
  """

  /// Person with female gender
  static let female = """
  {
    "name": "XiaoHong",
    "age": 18,
    "isChild": false,
    "gender": "female"
  }
  """

  /// Person with child flag
  static let child = """
  {
    "name": "XiaoMing",
    "age": 8,
    "isChild": true,
    "gender": "male"
  }
  """

  /// Person with null values (should use defaults)
  static let withNulls = """
  {
    "name": null,
    "age": null,
    "isChild": null,
    "gender": null
  }
  """

  /// Person with extra fields (should be ignored)
  static let withExtraFields = """
  {
    "name": "WangWu",
    "age": 30,
    "isChild": false,
    "gender": "male",
    "email": "wangwu@example.com",
    "phone": "1234567890"
  }
  """
}

// MARK: - Enum JSON Mocks

enum EnumJsonMock {
  // MARK: Gender (String raw value)

  static let genderMale = """
  "male"
  """

  static let genderFemale = """
  "female"
  """

  // MARK: AccessLevel (no raw value)

  static let accessGuest = """
  "guest"
  """

  static let accessAdmin = """
  "admin"
  """
}

// MARK: - Nested Object JSON Mocks

enum NestedJsonMock {
  /// Person with nested address
  static let personWithAddress = """
  {
    "name": "ZhangSan",
    "address": {
      "city": "Beijing",
      "street": "ChangAn Street",
      "zipCode": "100000"
    }
  }
  """

  /// Empty nested object
  static let emptyNested = """
  {
    "name": "LiSi",
    "address": {}
  }
  """
}

// MARK: - Array JSON Mocks

enum ArrayJsonMock {
  /// Object with string array
  static let stringArray = """
  {
    "tags": ["swift", "macro", "codable"]
  }
  """

  /// Object with empty array
  static let emptyArray = """
  {
    "tags": []
  }
  """

  /// Object with integer array
  static let intArray = """
  {
    "scores": [100, 95, 88, 72]
  }
  """
}

// MARK: - Complex JSON Mocks

enum ComplexJsonMock {
  /// Complete user profile with multiple nested objects
  static let userProfile = """
  {
    "id": 12345,
    "username": "developer",
    "profile": {
      "firstName": "John",
      "lastName": "Doe",
      "age": 28,
      "isVerified": true
    },
    "settings": {
      "theme": "dark",
      "notifications": true,
      "language": "zh-CN"
    },
    "roles": ["user", "admin", "developer"]
  }
  """

  /// Minimal user profile
  static let minimalProfile = """
  {
    "id": 1,
    "username": "guest"
  }
  """
}

// MARK: - Edge Cases JSON Mocks

enum EdgeCaseJsonMock {
  /// Unicode characters - using ASCII safe strings
  static let unicode = """
  {
    "name": "Hello World",
    "emoji": "Test123"
  }
  """

  /// Special characters in strings
  static let specialChars = """
  {
    "name": "Test\\nWith\\tEscapes",
    "quote": "He said \\"Hello\\""
  }
  """

  /// Large numbers
  static let largeNumbers = """
  {
    "bigInt": 9223372036854775807,
    "bigDouble": 1.7976931348623157E+308
  }
  """

  /// Boolean variations
  static let booleans = """
  {
    "trueValue": true,
    "falseValue": false
  }
  """

  /// Floating point numbers
  static let floatingPoints = """
  {
    "float": 3.14159,
    "double": 2.718281828459045,
    "negative": -123.456
  }
  """
}
