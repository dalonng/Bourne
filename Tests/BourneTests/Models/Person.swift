//
//  Person.swift
//  Bourne
//
//  Created by d on 2025/03/11.
//

import Foundation

@testable import Bourne

@Bourne
public struct Person {
  public let name: String
  public let age: Int
  public var isChild: Bool

  @JSONProperty(defaultValue: Gender.male)
  public let gender: Gender
}

@BourneEnum
public enum Gender: String, Sendable {
  case male
  case female
}

@BourneEnum
public enum AccessLevel {
  case guest
  case admin
}

// MARK: - Address Model

@Bourne
public struct Address {
  public let city: String
  public let street: String
  public let zipCode: String
}

// MARK: - PersonWithAddress Model

@Bourne
public struct PersonWithAddress {
  public let name: String
  public let address: Address
}

// MARK: - TagCollection Model

@Bourne
public struct TagCollection {
  public let tags: [String]
}

// MARK: - ScoreCollection Model

@Bourne
public struct ScoreCollection {
  public let scores: [Int]
}

// MARK: - Profile Model

@Bourne
public struct Profile {
  public let firstName: String
  public let lastName: String
  public let age: Int
  public let isVerified: Bool
}

// MARK: - Settings Model

@Bourne
public struct Settings {
  public let theme: String
  public let notifications: Bool
  public let language: String
}

// MARK: - UserProfile Model (simplified - nested objects use default .empty)

@Bourne
public struct UserProfile {
  public let id: Int
  public let username: String
  public let profile: Profile
  public let settings: Settings
  public let roles: [String]
}

// MARK: - Unicode Model

@Bourne
public struct UnicodeModel {
  public let name: String
  public let emoji: String
}

// MARK: - NumberModel

@Bourne
public struct NumberModel {
  public let bigInt: Int
  public let bigDouble: Double
}

// MARK: - FloatModel

@Bourne
public struct FloatModel {
  public let float: Float
  public let double: Double
  public let negative: Double
}

// MARK: - BoolModel

@Bourne
public struct BoolModel {
  public let trueValue: Bool
  public let falseValue: Bool
}
