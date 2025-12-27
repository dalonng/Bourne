
import Bourne
@testable import BourneMacros
import Foundation
import Testing

@Bourne
struct DecimalModel {
  var value: Decimal
}

@Test func decimalDecode() throws {
  let model: DecimalModel = try """
  {
    "value": 12.34
  }
  """.forceDecode()

  #expect(model.value == 12.34)
}
