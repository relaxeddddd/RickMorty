import UIKit

/// CharacterViewController for TabBar
final class CharacterViewController: UIViewController, CharacterViewDelegate {
  
  private let characterListView = CharacterView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
  }
  
  // MARK: - Private func
  
  private func setUpView() {
    view.backgroundColor = .systemBackground
    title = "Episodes"
    view.addSubview(characterListView)
    characterListView.delegate = self
    NSLayoutConstraint.activate([
      characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  // MARK: - CharacterListViewDelegate
  
  func characterView(_ characterView: CharacterView, didSelectCharacter character: CharactersModel) {
    // Открытие экрана с детальной информации о персонаже
    let viewModel = CharacterDetailViewViewModel(character: character)
    let detailVC = CharacterDetailViewController(viewModel: viewModel)
    detailVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
