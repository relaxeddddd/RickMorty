import Foundation

@frozen enum Endpoint: String, CaseIterable, Hashable {
  case character
  case location
  case episode
}
