import UIKit

protocol CharacterViewDelegate: AnyObject {
  func characterView(
    _ characterView: CharacterView,
    didSelectCharacter character: CharactersModel
  )
}

/// CharacterView
final class CharacterView: UIView {
  
  // MARK: - Public properties
  
  public weak var delegate: CharacterViewDelegate?
  
  // MARK: - Private properties

  private let viewModel = CharacterListViewViewModel()
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
    return collectionView
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(collectionView)
    addConstraints()
    viewModel.delegate = self
    viewModel.fetchCharacters()
    setUpCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("error CharacterListView")
  }
  
  // MARK: - Private func
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  private func setUpCollectionView() {
    collectionView.dataSource = viewModel
    collectionView.delegate = viewModel
  }
}

// MARK: - CharacterCollectionViewModelDelegate
extension CharacterView: CharacterCollectionViewModelDelegate {
  func didSelectCharacter(_ character: CharactersModel) {
    delegate?.characterView(self, didSelectCharacter: character)
  }
  
  func didLoadInitialCharacters() {
    collectionView.isHidden = false
    collectionView.reloadData()
    UIView.animate(withDuration: 0.4) {
      self.collectionView.alpha = 1
    }
  }
  
  func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
    collectionView.performBatchUpdates {
      self.collectionView.insertItems(at: newIndexPaths)
    }
  }
}
