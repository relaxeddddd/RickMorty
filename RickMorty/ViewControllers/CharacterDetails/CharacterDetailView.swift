import UIKit

/// CharacterDetailView
final class CharacterDetailView: UIView {
  
  // MARK: - Public properties
  
  public var tableView: UITableView?
  
  // MARK: - Private properties
  
  private let viewModel: CharacterDetailViewViewModel

  // MARK: - Init
  
  init(frame: CGRect, viewModel: CharacterDetailViewViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    setViewUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("error CharacterDetailView")
  }
  
  // MARK: - Private func
  
  private func setViewUI() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemBackground
    let tableView = createTableView()
    self.tableView = tableView
    addSubview(tableView)
    addConstraints()
  }
  
  private func addConstraints() {
    guard let tableView = tableView else {
      return
    }
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  private func createTableView() -> UITableView {
    let tableView = UITableView()
    tableView.register(CharacterDetailTableViewCell.self, forCellReuseIdentifier: CharacterDetailTableViewCell.cellIdentifer)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }
}
