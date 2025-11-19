//
//  Person.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

@testable import Bourne
import Foundation

@Bourne
public struct Person {
  public let name: String
  public let age: Int
  public var isChild: Bool

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender
}

@Bourne
public enum Gender: String, Sendable {
  case male
  case female
}

@Bourne
public enum AccessLevel {
  case guest
  case admin
}
