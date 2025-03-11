//
//  DecodeTests.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

@testable import BourneMacros
import Foundation
import Testing

@Test func testDecode() throws {
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

@Test func testZeroDecode() throws {
  let person: Person = try """
  {
  }
  """.forceDecode()

  #expect(person.name == "")
  #expect(person.age == 0)
  #expect(person.isChild == false)
  #expect(person.gender == .male)
}
