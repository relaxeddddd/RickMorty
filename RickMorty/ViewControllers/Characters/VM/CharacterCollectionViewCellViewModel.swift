import Foundation
import UIKit

protocol EpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

/// CharacterCollectionViewCellViewModel
final class CharacterCollectionViewCellViewModel: Hashable {
  
  // MARK: - Public properties
  public let characterName: String
  public let characterStatus: String
  
  // MARK: - Private propeties
  private let episodeDataUrl: URL?
  private let characterImageUrl: URL?
  private var isFetching = false
  private var dataBlock: ((EpisodeDataRender) -> Void)?
  
  private var episode: EpisodesModel? {
    didSet {
      guard let model = episode else {
        return
      }
      dataBlock?(model)
    }
  }
  
  // MARK: - Init
  
  init(
    characterName: String,
    characterStatus: String,
    characterImageUrl: URL?,
    episodeDataUrl: URL?
  ) {
    self.characterName = characterName
    self.characterStatus = characterStatus
    self.characterImageUrl = characterImageUrl
    self.episodeDataUrl = episodeDataUrl
  }
  
  // MARK: - Hashable
  
  static func == (lhs: CharacterCollectionViewCellViewModel, rhs: CharacterCollectionViewCellViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(characterName)
    hasher.combine(characterStatus)
    hasher.combine(characterImageUrl)
    hasher.combine(episodeDataUrl)
  }
  
  
  // MARK: - Public func
  
  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    // TODO: Abstract to Image Manager
    guard let url = characterImageUrl else {
      completion(.failure(URLError(.badURL)))
      return
    }
    ImageLoader.shared.downloadImage(url, completion: completion)
  }
  
  public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
    self.dataBlock = block
  }
  
  public func fetchEpisode() {
    guard !isFetching else {
      if let model = episode {
        dataBlock?(model)
      }
      return
    }
    
    guard let url = episodeDataUrl,
          let request = Request(url: url) else {
      return
    }
    
    isFetching = true
    
    Service.shared.execute(request, expecting: EpisodesModel.self) { [weak self] result in
      switch result {
      case .success(let model):
        DispatchQueue.main.async {
          self?.episode = model
        }
      case .failure(let failure):
        print(String(describing: failure))
      }
    }
  }
}
