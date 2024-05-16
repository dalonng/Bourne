import Bourne

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@Bourne
struct Person: Codable {
  let name: String
  let age: Int
  let isChild: Bool
}
