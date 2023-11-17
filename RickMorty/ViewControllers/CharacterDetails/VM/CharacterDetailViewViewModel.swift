import UIKit

/// CharacterDetailViewViewModel
final class CharacterDetailViewViewModel {
  
  // MARK: - Public properties
  public let character: CharactersModel
  public var information: [CharacterDetailCollectionViewCellViewModel] = []
  
  // MARK: - Init
  
  init(character: CharactersModel) {
    self.character = character
    setUpSections()
  }
  
  // MARK: - Private func
  private func setUpSections() {
    information = [
      .init(characterModel: character)]
  }
  
  // MARK: - Public func
  
  public var title: String {
    character.name.uppercased()
  }
}
