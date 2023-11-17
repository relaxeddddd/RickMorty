import UIKit

/// Single cell for a character
final class CharacterCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "CharacterCollectionViewCell"
  
  // MARK: - Private properties
  private let episodesNumberLabel = CustomCharacterAPILabel()
  private let episodesNameLabel = CustomCharacterAPILabel()
  private let statusLabel = CustomCharacterAPILabel()
  
  private let characterImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let nameCharacterLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let episodeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "monitorPlay")
    imageView.tintColor = .gray
    return imageView
  }()
  
  private let episodesView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(named: "")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    return view
  }()
  
  private let likeImageView: UIView = {
    let imageView = UIView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let heartImageView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "heart")
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private let tapGesture: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer()
    return gesture
  }()
  
  private var isLiked = false
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCellUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("error CharacterCell")
  }
  
  // MARK: - Override
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setUpLayer()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    characterImage.image = nil
    nameCharacterLabel.text = nil
    statusLabel.text = nil
    episodesNumberLabel.text = nil
    episodesNameLabel.text = nil
  }
  
  // MARK: - @Objc private func
  
  @objc private func likeButtonTapped() {
    isLiked.toggle()
    
    UIView.transition(with: heartImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
      self.heartImageView.image = self.isLiked ? UIImage(named: "likeHeart") : UIImage(named: "heart")
    }, completion: nil)
  }
  
  // MARK: - Private func
  
  private func setupCellUI() {
    contentView.backgroundColor = .white
    contentView.addSubview(characterImage)
    contentView.addSubview(nameCharacterLabel)
    contentView.addSubview(statusLabel)
    contentView.addSubview(episodesView)
    episodesView.addSubview(episodeImageView)
    episodesView.addSubview(episodesNameLabel)
    episodesView.addSubview(episodesNumberLabel)
    episodesView.addSubview(likeImageView)
    likeImageView.addSubview(heartImageView)
    addConstraints()
    setUpLayer()
    tapGesture.addTarget(self, action: #selector(likeButtonTapped))
    likeImageView.addGestureRecognizer(tapGesture)
  }
  
  private func setUpLayer() {
    contentView.layer.cornerRadius = 8
    contentView.layer.shadowColor = UIColor.label.cgColor
    contentView.layer.cornerRadius = 4
    contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    contentView.layer.shadowOpacity = 0.3
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      statusLabel.heightAnchor.constraint(equalToConstant: 30),
      nameCharacterLabel.heightAnchor.constraint(equalToConstant: 30),
      
      statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
      nameCharacterLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      nameCharacterLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
      
      statusLabel.topAnchor.constraint(equalTo: nameCharacterLabel.bottomAnchor, constant: 3),
      nameCharacterLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
      
      episodesView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
      episodesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      episodesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      episodesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      characterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      characterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      characterImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      characterImage.bottomAnchor.constraint(equalTo: nameCharacterLabel.topAnchor, constant: -3),
      
      episodeImageView.leadingAnchor.constraint(equalTo: episodesView.leadingAnchor, constant: 21.92),
      episodeImageView.centerYAnchor.constraint(equalTo: episodesView.centerYAnchor),
      episodeImageView.widthAnchor.constraint(equalToConstant: 33),
      episodeImageView.heightAnchor.constraint(equalToConstant: 34),
      
      episodesNameLabel.centerYAnchor.constraint(equalTo: episodesView.centerYAnchor),
      episodesNameLabel.leadingAnchor.constraint(equalTo: episodeImageView.trailingAnchor, constant: 10),
      episodesNameLabel.widthAnchor.constraint(equalToConstant: 130),
      
      episodesNumberLabel.leadingAnchor.constraint(equalTo: episodesNameLabel.trailingAnchor),
      episodesNumberLabel.centerYAnchor.constraint(equalTo: episodeImageView.centerYAnchor),
      
      likeImageView.trailingAnchor.constraint(equalTo: episodesView.trailingAnchor, constant: -18),
      likeImageView.centerYAnchor.constraint(equalTo: episodesView.centerYAnchor),
      likeImageView.widthAnchor.constraint(equalToConstant: 41),
      likeImageView.heightAnchor.constraint(equalToConstant: 40),
      
      heartImageView.centerXAnchor.constraint(equalTo: likeImageView.centerXAnchor),
      heartImageView.centerYAnchor.constraint(equalTo: likeImageView.centerYAnchor)
      
    ])
  }
  
  // MARK: - Public func
  
  public func configure(with viewModel: CharacterCollectionViewCellViewModel) {
    nameCharacterLabel.text = viewModel.characterName
    statusLabel.text = viewModel.characterStatus
    
    viewModel.registerForData { [weak self] data in
      self?.episodesNameLabel.text = data.name
      self?.episodesNumberLabel.text = " | \(data.episode)"
    }
    viewModel.fetchEpisode()
    
    viewModel.fetchImage { [weak self] result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          let image = UIImage(data: data)
          self?.characterImage.image = image
        }
      case .failure(let error):
        print(String(describing: error))
        break
      }
    }
  }
}
