import UIKit

/// CharacterDetailCollectionViewCellViewModel
final class CharacterDetailCollectionViewCellViewModel {
  //MARK: - Public properties
  public let characterModel: CharactersModel?
  
  // MARK: - Init
  init(characterModel: CharactersModel?) {
    self.characterModel = characterModel
  }
  
  // MARK: - Public func
  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let imageUrl = URL(string: characterModel?.image ?? "nil") else {
      completion(.failure(URLError(.badURL)))
      return
    }
    ImageLoader.shared.downloadImage(imageUrl, completion: completion)
  }
}
