//
//  JsonParsingTests.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

import Foundation
import Testing

@testable import Bourne

// MARK: - Person Parsing Tests

@Suite("Person JSON Parsing Tests")
struct PersonParsingTests {
  @Test("Parse complete person JSON")
  func testParseCompletePerson() throws {
    let person: Person = try PersonJsonMock.complete.forceDecode()

    #expect(person.name == "ZhangSan")
    #expect(person.age == 25)
    #expect(person.isChild == false)
    #expect(person.gender == .male)
  }

  @Test("Parse empty JSON uses default values")
  func testParseEmptyPerson() throws {
    let person: Person = try PersonJsonMock.empty.forceDecode()

    #expect(person.name == "")
    #expect(person.age == 0)
    #expect(person.isChild == false)
    #expect(person.gender == .male)  // default from JSONProperty
  }

  @Test("Parse person with only name")
  func testParseNameOnly() throws {
    let person: Person = try PersonJsonMock.nameOnly.forceDecode()

    #expect(person.name == "LiSi")
    #expect(person.age == 0)
    #expect(person.isChild == false)
    #expect(person.gender == .male)
  }

  @Test("Parse female person")
  func testParseFemalePerson() throws {
    let person: Person = try PersonJsonMock.female.forceDecode()

    #expect(person.name == "XiaoHong")
    #expect(person.age == 18)
    #expect(person.isChild == false)
    #expect(person.gender == .female)
  }

  @Test("Parse child person")
  func testParseChildPerson() throws {
    let person: Person = try PersonJsonMock.child.forceDecode()

    #expect(person.name == "XiaoMing")
    #expect(person.age == 8)
    #expect(person.isChild == true)
    #expect(person.gender == .male)
  }

  @Test("Parse person ignores extra fields")
  func testParseIgnoresExtraFields() throws {
    let person: Person = try PersonJsonMock.withExtraFields.forceDecode()

    #expect(person.name == "WangWu")
    #expect(person.age == 30)
    #expect(person.isChild == false)
    #expect(person.gender == .male)
  }
}

// MARK: - Enum Parsing Tests

@Suite("Enum JSON Parsing Tests")
struct EnumParsingTests {
  @Test("Parse Gender male")
  func testParseGenderMale() throws {
    let gender: Gender = try EnumJsonMock.genderMale.forceDecode()
    #expect(gender == .male)
  }

  @Test("Parse Gender female")
  func testParseGenderFemale() throws {
    let gender: Gender = try EnumJsonMock.genderFemale.forceDecode()
    #expect(gender == .female)
  }

  @Test("Parse AccessLevel guest")
  func testParseAccessGuest() throws {
    let access: AccessLevel = try EnumJsonMock.accessGuest.forceDecode()
    #expect(access == .guest)
  }

  @Test("Parse AccessLevel admin")
  func testParseAccessAdmin() throws {
    let access: AccessLevel = try EnumJsonMock.accessAdmin.forceDecode()
    #expect(access == .admin)
  }
}

// MARK: - Nested Object Parsing Tests

@Suite("Nested Object JSON Parsing Tests")
struct NestedObjectParsingTests {
  @Test("Parse person with nested address")
  func testParsePersonWithAddress() throws {
    let person: PersonWithAddress = try NestedJsonMock.personWithAddress.forceDecode()

    #expect(person.name == "ZhangSan")
    #expect(person.address.city == "Beijing")
    #expect(person.address.street == "ChangAn Street")
    #expect(person.address.zipCode == "100000")
  }

  @Test("Parse empty nested object uses defaults")
  func testParseEmptyNested() throws {
    let person: PersonWithAddress = try NestedJsonMock.emptyNested.forceDecode()

    #expect(person.name == "LiSi")
    #expect(person.address.city == "")
    #expect(person.address.street == "")
    #expect(person.address.zipCode == "")
  }
}

// MARK: - Array Parsing Tests

@Suite("Array JSON Parsing Tests")
struct ArrayParsingTests {
  @Test("Parse string array")
  func testParseStringArray() throws {
    let collection: TagCollection = try ArrayJsonMock.stringArray.forceDecode()

    #expect(collection.tags.count == 3)
    #expect(collection.tags[0] == "swift")
    #expect(collection.tags[1] == "macro")
    #expect(collection.tags[2] == "codable")
  }

  @Test("Parse empty array")
  func testParseEmptyArray() throws {
    let collection: TagCollection = try ArrayJsonMock.emptyArray.forceDecode()

    #expect(collection.tags.isEmpty)
  }

  @Test("Parse integer array")
  func testParseIntArray() throws {
    let collection: ScoreCollection = try ArrayJsonMock.intArray.forceDecode()

    #expect(collection.scores.count == 4)
    #expect(collection.scores[0] == 100)
    #expect(collection.scores[1] == 95)
    #expect(collection.scores[2] == 88)
    #expect(collection.scores[3] == 72)
  }
}

// MARK: - Complex Object Parsing Tests

@Suite("Complex Object JSON Parsing Tests")
struct ComplexObjectParsingTests {
  @Test("Parse complete user profile")
  func testParseCompleteUserProfile() throws {
    let user: UserProfile = try ComplexJsonMock.userProfile.forceDecode()

    #expect(user.id == 12345)
    #expect(user.username == "developer")
    #expect(user.profile.firstName == "John")
    #expect(user.profile.lastName == "Doe")
    #expect(user.profile.age == 28)
    #expect(user.profile.isVerified == true)
    #expect(user.settings.theme == "dark")
    #expect(user.settings.notifications == true)
    #expect(user.settings.language == "zh-CN")
    #expect(user.roles.count == 3)
    #expect(user.roles.contains("admin"))
  }

  @Test("Parse minimal user profile uses defaults")
  func testParseMinimalUserProfile() throws {
    let user: UserProfile = try ComplexJsonMock.minimalProfile.forceDecode()

    #expect(user.id == 1)
    #expect(user.username == "guest")
    #expect(user.profile.firstName == "")
    #expect(user.profile.lastName == "")
    #expect(user.settings.theme == "")
    #expect(user.roles.isEmpty)
  }
}

// MARK: - Edge Cases Parsing Tests

@Suite("Edge Cases JSON Parsing Tests")
struct EdgeCasesParsingTests {
  @Test("Parse Unicode characters")
  func testParseUnicode() throws {
    let model: UnicodeModel = try EdgeCaseJsonMock.unicode.forceDecode()

    #expect(model.name == "Hello World")
    #expect(model.emoji == "Test123")
  }

  @Test("Parse large numbers")
  func testParseLargeNumbers() throws {
    let model: NumberModel = try EdgeCaseJsonMock.largeNumbers.forceDecode()

    #expect(model.bigInt == 9223372036854775807)
    #expect(model.bigDouble == 1.7976931348623157E+308)
  }

  @Test("Parse boolean values")
  func testParseBooleans() throws {
    let model: BoolModel = try EdgeCaseJsonMock.booleans.forceDecode()

    #expect(model.trueValue == true)
    #expect(model.falseValue == false)
  }

  @Test("Parse floating point numbers")
  func testParseFloatingPoints() throws {
    let model: FloatModel = try EdgeCaseJsonMock.floatingPoints.forceDecode()

    #expect(model.float > 3.14 && model.float < 3.15)
    #expect(model.double > 2.718 && model.double < 2.719)
    #expect(model.negative == -123.456)
  }
}

// MARK: - Encoding Tests

@Suite("JSON Encoding Tests")
struct JsonEncodingTests {
  @Test("Encode and decode person preserves data")
  func testEncodeDecodePerson() throws {
    let original = Person(name: "Test", age: 30, isChild: false, gender: .female)
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    let decoded: Person = try JSONDecoder().decode(Person.self, from: data)

    #expect(decoded.name == original.name)
    #expect(decoded.age == original.age)
    #expect(decoded.isChild == original.isChild)
    #expect(decoded.gender == original.gender)
  }

  @Test("Encode and decode enum preserves value")
  func testEncodeDecodeEnum() throws {
    let original = Gender.female
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    let decoded: Gender = try JSONDecoder().decode(Gender.self, from: data)

    #expect(decoded == original)
  }

  @Test("Encode and decode AccessLevel preserves value")
  func testEncodeDecodeAccessLevel() throws {
    let original = AccessLevel.admin
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    let decoded: AccessLevel = try JSONDecoder().decode(AccessLevel.self, from: data)

    #expect(decoded == original)
  }

  @Test("Encode and decode nested object preserves data")
  func testEncodeDecodeNested() throws {
    let original = PersonWithAddress(
      name: "EncodeTest",
      address: Address(city: "Shanghai", street: "Nanjing Road", zipCode: "200000")
    )
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    let decoded: PersonWithAddress = try JSONDecoder().decode(PersonWithAddress.self, from: data)

    #expect(decoded.name == original.name)
    #expect(decoded.address.city == original.address.city)
    #expect(decoded.address.street == original.address.street)
    #expect(decoded.address.zipCode == original.address.zipCode)
  }

  @Test("Encode and decode array preserves data")
  func testEncodeDecodeArray() throws {
    let original = TagCollection(tags: ["a", "b", "c"])
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    let decoded: TagCollection = try JSONDecoder().decode(TagCollection.self, from: data)

    #expect(decoded.tags == original.tags)
  }
}

// MARK: - Empty & Copy Tests

@Suite("Empty and Copy Method Tests")
struct EmptyCopyTests {
  @Test("Person.empty has default values")
  func testPersonEmpty() {
    let empty = Person.empty

    #expect(empty.name == "")
    #expect(empty.age == 0)
    #expect(empty.isChild == false)
    #expect(empty.gender == .male)
  }

  @Test("Person.copy creates modified copy")
  func testPersonCopy() {
    let original = Person(name: "Original", age: 20, isChild: false, gender: .male)
    let copied = original.copy(name: "Copied", age: 25)

    #expect(copied.name == "Copied")
    #expect(copied.age == 25)
    #expect(copied.isChild == original.isChild)
    #expect(copied.gender == original.gender)
  }

  @Test("Address.empty has default values")
  func testAddressEmpty() {
    let empty = Address.empty

    #expect(empty.city == "")
    #expect(empty.street == "")
    #expect(empty.zipCode == "")
  }

  @Test("Address.copy creates modified copy")
  func testAddressCopy() {
    let original = Address(city: "Beijing", street: "ChangAn Street", zipCode: "100000")
    let copied = original.copy(city: "Shanghai")

    #expect(copied.city == "Shanghai")
    #expect(copied.street == original.street)
    #expect(copied.zipCode == original.zipCode)
  }
}
