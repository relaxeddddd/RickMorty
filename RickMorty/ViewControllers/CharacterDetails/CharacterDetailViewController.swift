import UIKit
import Photos

final class CharacterDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: - Private properties
  private let viewModel: CharacterDetailViewViewModel
  private let detailView: CharacterDetailView
  private let cell: CharacterDetailCollectionViewCell?
  private let goBackLabel: UILabel = {
    let title = UILabel()
    title.font = .systemFont(ofSize: 18, weight: .bold)
    title.text = "GO BACK"
    title.textColor = .black
    title.translatesAutoresizingMaskIntoConstraints = false
    return title
  }()
  
  private let arrowImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "arrowBack")
    image.contentMode = .scaleAspectFill
    image.tintColor = .black
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private let logoRightBtnImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "logoBlack")
    image.tintColor = .black
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private let leftBarBtnView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let rightBarBtnView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Init
  
  init(viewModel: CharacterDetailViewViewModel) {
    self.viewModel = viewModel
    self.detailView = CharacterDetailView(frame: .zero, viewModel: viewModel)
    self.cell = CharacterDetailCollectionViewCell(frame: .zero)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Error CharacterDetailViewController")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
  }
  
  // MARK: - Private func
  
  private func setView() {
    view.backgroundColor = .systemBackground
    view.addSubview(detailView)
    detailView.tableView?.delegate = self
    detailView.tableView?.dataSource = self
    detailView.translatesAutoresizingMaskIntoConstraints = false
    leftBarBtnView.addGestureRecognizer(gesture())
    leftBarBtnView.addSubview(arrowImageView)
    leftBarBtnView.addSubview(goBackLabel)
    rightBarBtnView.addSubview(logoRightBtnImageView)
    addConstraints()
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarBtnView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarBtnView)
  }
  
  private func gesture() -> UIGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
    return tapGesture
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      leftBarBtnView.widthAnchor.constraint(equalToConstant: 200),
      leftBarBtnView.heightAnchor.constraint(equalToConstant: 100),

      
      arrowImageView.topAnchor.constraint(equalTo: leftBarBtnView.topAnchor),
      arrowImageView.leadingAnchor.constraint(equalTo: leftBarBtnView.leadingAnchor),
      arrowImageView.bottomAnchor.constraint(equalTo: leftBarBtnView.bottomAnchor),
      arrowImageView.widthAnchor.constraint(equalToConstant: 24),
      arrowImageView.heightAnchor.constraint(equalToConstant: 24),
      
      goBackLabel.topAnchor.constraint(equalTo: leftBarBtnView.topAnchor),
      goBackLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 8),
      goBackLabel.bottomAnchor.constraint(equalTo: leftBarBtnView.bottomAnchor),
      
      logoRightBtnImageView.trailingAnchor.constraint(equalTo: rightBarBtnView.trailingAnchor, constant: -17),
      logoRightBtnImageView.topAnchor.constraint(equalTo: rightBarBtnView.topAnchor, constant: 6),
      logoRightBtnImageView.bottomAnchor.constraint(equalTo: rightBarBtnView.bottomAnchor, constant: -5),
    ])
  }
  
  // MARK: @Objc private actions
  
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource, PresentVCDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.information.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModels = viewModel.information[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: CharacterDetailCollectionViewCell.cellIdentifer,
      for: indexPath) as? CharacterDetailCollectionViewCell else { return UITableViewCell() }
    cell.selectionStyle = .none
    cell.delegateVC = self
    cell.configure(with: viewModels)
    return cell
  }
}
