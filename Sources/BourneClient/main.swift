import Bourne

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

@Bourne
struct Person: Codable {
  let name: String
  let age: Int
  let isChild: Bool
}

@Bourne
public struct Person2: Codable {
  let name: String
  let age: Int
  let isChild: Bool
}

func main() {
  print("The value \(result) was produced by the code \"\(code)\"")
}
