import UIKit

// MARK: - CharacterCollectionViewModelDelegate

protocol CharacterCollectionViewModelDelegate: AnyObject {
  func didLoadInitialCharacters()
  func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
  func didSelectCharacter(_ character: CharactersModel)
}

/// View Model to handle character list view logic
final class CharacterListViewViewModel: NSObject {
  
  // MARK: - Public properties
  
  public weak var delegate: CharacterCollectionViewModelDelegate?
  public var shouldShowLoadMoreIndicator: Bool {
    return apiInfo?.next != nil
  }
  
  // MARK: - Private properties
  
  private var isLoadingMoreCharacters = false
  private var cellViewModels: [CharacterCollectionViewCellViewModel] = []
  private var apiInfo: CharacterResponse.Info? = nil
  private var characters: [CharactersModel] = [] {
    didSet {
      for character in characters {
        guard let episode = character.episode.first else { continue }
        let viewModel = CharacterCollectionViewCellViewModel(
          characterName: character.name,
          characterStatus: character.status,
          characterImageUrl: URL(string: character.image),
          episodeDataUrl: URL(string: episode)
        )
        if !cellViewModels.contains(viewModel) {
          cellViewModels.append(viewModel)
        }
      }
    }
  }
  
  // MARK: - Public func
  
  private func setEpisode(_ urls: [String], character: CharactersModel) -> URL? {
    var singleUrl: URL?
    
    for url in urls {
      let urlStringWithCharacterName = url + character.name
      if let urlWithCharacterName = URL(string: urlStringWithCharacterName) {
        singleUrl = urlWithCharacterName
      }
    }
    
    return singleUrl
  }
  
  public func fetchCharacters() {
    Service.shared.execute(
      .listCharactersRequests,
      expecting: CharacterResponse.self
    ) { [weak self] result in
      switch result {
      case .success(let responseModel):
        let results = responseModel.results
        let info = responseModel.info
        self?.characters = results
        self?.apiInfo = info
        DispatchQueue.main.async {
          self?.delegate?.didLoadInitialCharacters()
        }
      case .failure(let error):
        print(String(describing: error))
      }
    }
  }
  
  /// Pagination
  public func fetchAdditionalCharacters(url: URL) {
    guard !isLoadingMoreCharacters else {
      return
    }
    isLoadingMoreCharacters = true
    guard let request = Request(url: url) else {
      isLoadingMoreCharacters = false
      return
    }
    
    Service.shared.execute(request, expecting: CharacterResponse.self) { [weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let responseModel):
        let moreResults = responseModel.results
        let info = responseModel.info
        strongSelf.apiInfo = info
        
        let originalCount = strongSelf.characters.count
        let newCount = moreResults.count
        let total = originalCount+newCount
        let startingIndex = total - newCount
        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
          return IndexPath(row: $0, section: 0)
        })
        strongSelf.characters.append(contentsOf: moreResults)
        
        DispatchQueue.main.async {
          strongSelf.delegate?.didLoadMoreCharacters(
            with: indexPathsToAdd
          )
          
          strongSelf.isLoadingMoreCharacters = false
        }
      case .failure(let failure):
        print(String(describing: failure))
        self?.isLoadingMoreCharacters = false
      }
    }
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellViewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? CharacterCollectionViewCell else { return UICollectionViewCell() }
    cell.inputViewController?.isEditing = true
    cell.configure(with: cellViewModels[indexPath.row])
    cell.layer.cornerRadius = 4
    cell.clipsToBounds = true
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bounds = UIScreen.main.bounds
    let width = Int(bounds.width-60)
    let heith = Int(bounds.height) / 2
    return CGSize(width: width, height: heith)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let character = characters[indexPath.row]
    delegate?.didSelectCharacter(character)
  }
}

// MARK: - ScrollView
extension CharacterListViewViewModel: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard shouldShowLoadMoreIndicator,
          !isLoadingMoreCharacters,
          !cellViewModels.isEmpty,
          let nextUrlString = apiInfo?.next,
          let url = URL(string: nextUrlString) else {
      return
    }
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height
      
      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        self?.fetchAdditionalCharacters(url: url)
      }
      t.invalidate()
    }
  }
}
