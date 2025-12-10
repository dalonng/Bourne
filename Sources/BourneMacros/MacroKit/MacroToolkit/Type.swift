import SwiftSyntax
import SwiftSyntaxBuilder

/// Wraps type syntax (e.g. `Result<Success, Failure>`).
public enum `Type`: TypeProtocol, SyntaxExpressibleByStringInterpolation {
  /// An array type (e.g. `[Int]`).
  case array(ArrayType)
  /// A `class` token in a conformance list. Equivalent to `AnyObject`.
  case classRestriction(ClassRestrictionType)
  /// A composition of two types (e.g. `Encodable & Decodable`). Used to
  /// combine protocol requirements.
  case composition(CompositionType)
  /// A some or any protocol type (e.g. `any T` or `some T`).
  case someOrAny(SomeOrAnyType)
  /// A dictionary type (e.g. `[Int: String]`).
  case dictionary(DictionaryType)
  /// A function type (e.g. `() -> ()`).
  case function(FunctionType)
  /// An implicitly unwrapped optional type (e.g. `Int!`).
  case implicitlyUnwrappedOptional(ImplicitlyUnwrappedOptionalType)
  /// A member type (e.g. `Array<Int>.Element`).
  case member(MemberType)
  /// A metatype (e.g. `Int.Type` or `Encodable.Protocol`).
  case metatype(MetatypeType)
  /// A placeholder for invalid types that the resilient parser ignored.
  case missing(MissingType)
  /// An optional type (e.g. `Int?`).
  case optional(OptionalType)
  /// A pack expansion type (e.g. `repeat each V`).
  case packExpansion(PackExpansionType)
  /// A pack reference type (e.g. `each V`).
  case packReference(PackReferenceType)
  /// A simple type (e.g. `Int` or `Box<Int>`).
  case simple(SimpleType)
  /// A suppressed type in a conformance position (e.g. `~Copyable`).
  case suppressed(SuppressedType)
  //// A tuple type (e.g. `(Int, String)`).
  case tuple(TupleType)

  public var _baseSyntax: TypeSyntax {
    let type: any TypeProtocol =
      switch self {
      case .array(let type): type
      case .classRestriction(let type): type
      case .composition(let type): type
      case .someOrAny(let type): type
      case .dictionary(let type): type
      case .function(let type): type
      case .implicitlyUnwrappedOptional(let type): type
      case .member(let type): type
      case .metatype(let type): type
      case .missing(let type): type
      case .optional(let type): type
      case .packExpansion(let type): type
      case .packReference(let type): type
      case .simple(let type): type
      case .suppressed(let type): type
      case .tuple(let type): type
      }
    return TypeSyntax(type._baseSyntax)
  }

  public var _attributedSyntax: AttributedTypeSyntax? {
    let type: any TypeProtocol =
      switch self {
      case .array(let type): type
      case .classRestriction(let type): type
      case .composition(let type): type
      case .someOrAny(let type): type
      case .dictionary(let type): type
      case .function(let type): type
      case .implicitlyUnwrappedOptional(let type): type
      case .member(let type): type
      case .metatype(let type): type
      case .missing(let type): type
      case .optional(let type): type
      case .packExpansion(let type): type
      case .packReference(let type): type
      case .simple(let type): type
      case .suppressed(let type): type
      case .tuple(let type): type
      }
    return type._attributedSyntax
  }

  /// Wrap a `TypeSyntax` (e.g. `Int?` or `MyStruct<[String]>!`).
  public init(_ syntax: TypeSyntax) {
    self.init(syntax, attributedSyntax: nil)
  }

  // swiftlint:disable:next cyclomatic_complexity
  private static func resolveType(from syntax: TypeSyntaxProtocol) -> Type {
    if let type = ArrayType(syntax) {
      return .array(type)
    } else if let type = ClassRestrictionType(syntax) {
      return .classRestriction(type)
    } else if let type = CompositionType(syntax) {
      return .composition(type)
    } else if let type = SomeOrAnyType(syntax) {
      return .someOrAny(type)
    } else if let type = DictionaryType(syntax) {
      return .dictionary(type)
    } else if let type = FunctionType(syntax) {
      return .function(type)
    } else if let type = ImplicitlyUnwrappedOptionalType(syntax) {
      return .implicitlyUnwrappedOptional(type)
    } else if let type = MemberType(syntax) {
      return .member(type)
    } else if let type = MetatypeType(syntax) {
      return .metatype(type)
    } else if let type = MissingType(syntax) {
      return .missing(type)
    } else if let type = OptionalType(syntax) {
      return .optional(type)
    } else if let type = PackExpansionType(syntax) {
      return .packExpansion(type)
    } else if let type = PackReferenceType(syntax) {
      return .packReference(type)
    } else if let type = SimpleType(syntax) {
      return .simple(type)
    } else if let type = SuppressedType(syntax) {
      return .suppressed(type)
    } else if let type = TupleType(syntax) {
      return .tuple(type)
    } else {
      fatalError("TODO: Implement wrappers for all types of type syntax")
    }
  }

  public init(_ syntax: TypeSyntax, attributedSyntax: AttributedTypeSyntax? = nil) {
    let syntax: TypeSyntaxProtocol = attributedSyntax ?? syntax
    self = Self.resolveType(from: syntax)
  }

  /// Allows string interpolation syntax to be used to express type syntax.
  public init(stringInterpolation: SyntaxStringInterpolation) {
    self.init(TypeSyntax(stringInterpolation: stringInterpolation))
  }

  /// A normalized description of the type (e.g. for `()` this would be `Void`).
  public var normalizedDescription: String {
    guard let tupleSyntax = _syntax.as(TupleTypeSyntax.self) else {
      return _syntax.withoutTrivia().description
    }
    if tupleSyntax.elements.count == 0 {
      return "Void"
    } else if tupleSyntax.elements.count == 1, let element = tupleSyntax.elements.first {
      return element.type.withoutTrivia().description
    } else {
      return _syntax.withoutTrivia().description
    }
  }

  /// Gets whether the type is a void type (i.e. `Void`, `()`, `(Void)`, `((((()))))`, etc.).
  public var isVoid: Bool {
    normalizedDescription == "Void"
  }

  /// Attempts to get the type as a simple type.
  public var asSimpleType: SimpleType? {
    switch self {
    case .simple(let type): type
    default: nil
    }
  }

  /// Attempts to get the type as a function type.
  public var asFunctionType: FunctionType? {
    switch self {
    case .function(let type): type
    default: nil
    }
  }
}

extension Type? {
  /// If `nil`, the type is considered void, otherwise the underlying type is queried (see ``Type/isVoid``).
  public var isVoid: Bool {
    guard let self = self else {
      return true
    }
    return self.isVoid
  }
}
