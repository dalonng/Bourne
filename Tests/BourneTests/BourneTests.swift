@testable import Bourne
import Testing
import XCTest

public struct Person {
  public let name: String

  @JSONProperty(defaultValue: 1, name: "Age")
  public let age: Int
  @JSONProperty(defaultValue: false, name: "is_child")
  public var isChild: Bool

  @JSONProperty(defaultValue: PersonType.child, name: "person_ype")
  public let personType: PersonType
}

extension Person {
  public enum PersonType {
    case child
    case boy
    case girl
  }
}

@Test func helloWorld() {
  let greeting = "Hello, world!"
  #expect(greeting == "Hello") // Expectation failed: (greeting → "Hello, world!") == "Hello"
}
