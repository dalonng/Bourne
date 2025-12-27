//
//  DecodeTests.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

import Foundation
import Testing

@testable import BourneMacros

@Test func decode() throws {
  let person: Person = try """
  {
    "name": "张三",
    "age": 25,
    "isChild": false,
    "gender": "male"
  }
  """.forceDecode()

  #expect(person.name == "张三")
  #expect(person.age == 25)
  #expect(person.isChild == false)
  #expect(person.gender == .male)
}

@Test func zeroDecode() throws {
  let person: Person = try """
  {
  }
  """.forceDecode()

  #expect(person.name == "")
  #expect(person.age == 0)
  #expect(person.isChild == false)
  #expect(person.gender == .male)
}

@Test func enumDecodeWithoutRawType() throws {
  let value: AccessLevel = try """
  "admin"
  """.forceDecode()

  #expect(value == .admin)
}

@Test func uUIDDecode() throws {
  let expected = UUID(uuidString: "2C7800CC-48CF-4CA8-9B4A-999F5613FE72")!
  let model: UUIDModel = try """
  {
    "identifier": "\(expected.uuidString)"
  }
  """.forceDecode()

  #expect(model.identifier == expected)
}

@Test func uUIDDefaultDecode() throws {
  let model: UUIDModel = try """
  {
  }
  """.forceDecode()

  #expect(model.identifier.uuidString.isEmpty == false)
}

@Test func uUIDDefaultFallbackWhenInvalid() throws {
  let defaultValue = UUID(uuid: uuid_t(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15))
  let model: UUIDDefaultModel = try """
  {
    "identifier": "invalid-uuid-value"
  }
  """.forceDecode()

  #expect(model.identifier == defaultValue)
}
