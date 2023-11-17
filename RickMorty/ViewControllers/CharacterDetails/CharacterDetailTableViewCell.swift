import UIKit
import Photos

/// Протокол для вызова Alerta на UIViewController
protocol PresentVCDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

/// CharacterDetailTableViewCell
final class CharacterDetailTableViewCell: UITableViewCell {
  
  // MARK: - CellID
  static let cellIdentifer = "CharacterInfoTableViewCell"
  
  // MARK: - Public properties
  weak var delegateVC: PresentVCDelegate?
  
  // MARK: - Private properties
  private let genderLabel = CustomLabel(text: "Gender")
  private let statusLabel = CustomLabel(text: "Status")
  private let speciesLabel = CustomLabel(text: "Specie")
  private let typeLabel = CustomLabel(text: "Type")
  private let originLabel = CustomLabel(text: "Origin")
  private let locationLabel = CustomLabel(text: "Location")
  private let genderApiLabel = CustomAPILabel()
  private let speciesApiLabel = CustomAPILabel()
  private let originApiLabel = CustomAPILabel()
  private let typeApiLabel = CustomAPILabel()
  private let locationApiLabel = CustomAPILabel()
  private let statusApiLabel = CustomAPILabel()
  public var characterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 200 / 2
    imageView.layer.borderWidth = 5
    imageView.layer.borderColor = UIColor.systemGray5.cgColor
    return imageView
  }()
  
  private let nameCharacterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 32, weight: .regular)
    return label
  }()

  private let titleContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.text = "Informations"
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 20, weight: .semibold)
      label.textColor = UIColor(named: "informationsLabel")
    return label
  }()

  private let cameraImageView: UIImageView = {
    let button = UIImageView()
    button.image = UIImage(named: "camera")
    button.tintColor = .black
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setCellUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("error CharacterDetailCell")
  }
  
  private func gesture() -> UIGestureRecognizer {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(taps))
    return tapGesture
  }
  
  @objc func taps() {
    showImagePickerActionSheet()
  }
  
  // MARK: - Private func
  
  
  private func setCellUI() {
    backgroundColor = .tertiarySystemBackground
    layer.cornerRadius = 8
    layer.masksToBounds = true
    contentView.addSubview(characterImageView)
    contentView.addSubview(titleContainerView)
    contentView.addSubview(nameCharacterLabel)
    contentView.addSubview(cameraImageView)
    cameraImageView.addGestureRecognizer(gesture())
    cameraImageView.isUserInteractionEnabled = true
    titleContainerView.addSubview(genderLabel)
    titleContainerView.addSubview(genderApiLabel)
    titleContainerView.addSubview(statusLabel)
    titleContainerView.addSubview(statusApiLabel)
    titleContainerView.addSubview(speciesLabel)
    titleContainerView.addSubview(speciesApiLabel)
    titleContainerView.addSubview(originLabel)
    titleContainerView.addSubview(originApiLabel)
    titleContainerView.addSubview(typeLabel)
    titleContainerView.addSubview(typeApiLabel)
    titleContainerView.addSubview(locationLabel)
    titleContainerView.addSubview(locationApiLabel)
    titleContainerView.addSubview(informationLabel)
    setUpConstraints()
  }
  
  public func showImagePickerActionSheet() {
    let actionSheet = UIAlertController(title: "Загрузите изображение", message: nil, preferredStyle: .actionSheet)
    
    let takePhotoAction = UIAlertAction(title: "Камера", style: .default) { _ in
      self.requestCameraAccess()
    }
    
    let choosePhotoAction = UIAlertAction(title: "Галерея", style: .default) { _ in
      self.requestPhotoLibraryAccess()
    }
    
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    
    actionSheet.addAction(takePhotoAction)
    actionSheet.addAction(choosePhotoAction)
    actionSheet.addAction(cancelAction)
    delegateVC?.present(actionSheet, animated: true, completion: nil)
  }
  
  private func requestCameraAccess() {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .notDetermined:
      firstRequestCameraAccess()
    case .restricted:
      showSettingsAlert()
    case .denied:
      showSettingsAlert()
    case .authorized:
      showImagePicker(sourceType: .camera)
    @unknown default:
      fatalError("Unexpected authorization status")
    }
  }
  
  private func firstRequestCameraAccess() {
    let alert = UIAlertController(
      title: "Разрешить доступ к камере?",
      message: "Это необходимо, чтобы сканировать штрихкоды, номер карты и использовать другие возможности",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Разрешить", style: .default) { _ in
      AVCaptureDevice.requestAccess(for: .video) { response in
        if response {
          DispatchQueue.main.async {
            self.showImagePicker(sourceType: .camera)
          }
        } else {
          DispatchQueue.main.async {
            self.showSettingsAlert()
          }
        }
      }
    })
    alert.addAction(UIAlertAction(title: "Отменить", style: .cancel) { _ in
      self.showSettingsAlert()
    })
    delegateVC?.present(alert, animated: true, completion: nil)
  }
  
  private func requestPhotoLibraryAccess() {
    let status = PHPhotoLibrary.authorizationStatus()
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          self.showImagePicker(sourceType: .photoLibrary)
        case .denied, .restricted:
          self.showSettingsAlert()
        case .notDetermined:
          self.firstRequestForAccessPhoto()
        case .limited:
          print("limited")
        @unknown default:
          fatalError("Unexpected authorization status")
        }
      }
  }
  
  private func firstRequestForAccessPhoto() {
    let alert = UIAlertController(
      title: "Разрешить доступ к «Фото»?",
      message: "Это необходимо для добавления ваших фотографий",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Разрешить", style: .default) { _ in
      let _ = PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        DispatchQueue.main.async {
          if status == .notDetermined {
            self.firstRequestForAccessPhoto()
          } else if status == .authorized {
            self.showImagePicker(sourceType: .photoLibrary)
          }
        }
      }
    })
    alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
    delegateVC?.present(alert, animated: true, completion: nil)
  }
  
  private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = sourceType
    imagePicker.delegate = self
    delegateVC?.present(imagePicker, animated: true, completion: nil)
  }
  
  private func showSettingsAlert() {
    let settingsAlert = UIAlertController(
      title: "Доступ к фотографиям/камере отключен?",
      message: "Пожалуйста, включите доступ к фотографиям/камере в настройках телефона",
      preferredStyle: .alert
    )
    settingsAlert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL)
      }
    })
    settingsAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    delegateVC?.present(settingsAlert, animated: true, completion: nil)
  }
  
  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 64),
      characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      characterImageView.heightAnchor.constraint(equalToConstant: 200),
      characterImageView.widthAnchor.constraint(equalToConstant: 200),
      
      cameraImageView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 9),
      cameraImageView.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
      cameraImageView.widthAnchor.constraint(equalToConstant: 32),
      cameraImageView.heightAnchor.constraint(equalToConstant: 32),
      
      nameCharacterLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 48),
      nameCharacterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      
      informationLabel.topAnchor.constraint(equalTo: nameCharacterLabel.bottomAnchor, constant: 18),
      informationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      
      titleContainerView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant: 16),
      titleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
      titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      titleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 27),
      
      genderLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      genderLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: 9),

      genderApiLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
      genderApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      statusLabel.topAnchor.constraint(equalTo: genderApiLabel.bottomAnchor, constant: 15),
      statusLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      statusApiLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
      statusApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      speciesLabel.topAnchor.constraint(equalTo: statusApiLabel.bottomAnchor, constant: 15),
      speciesLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      speciesApiLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 10),
      speciesApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      originLabel.topAnchor.constraint(equalTo: speciesApiLabel.bottomAnchor, constant: 15),
      originLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      originApiLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 10),
      originApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      typeLabel.topAnchor.constraint(equalTo: originApiLabel.bottomAnchor, constant: 15),
      typeLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      typeApiLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
      typeApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      locationLabel.topAnchor.constraint(equalTo: typeApiLabel.bottomAnchor, constant: 15),
      locationLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      
      locationApiLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
      locationApiLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 16),
      locationApiLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: -10)
    ])
  }
  
  // MARK: - Override
  
  override func prepareForReuse() {
    super.prepareForReuse()
    nameCharacterLabel.text = nil
    genderApiLabel.text = nil
    statusApiLabel.text = nil
    speciesApiLabel.text = nil
    originApiLabel.text = nil
    typeApiLabel.text = nil
    locationApiLabel.text = nil
  }
  
  // MARK: - Public func
  
  public func configure(with viewModel: CharacterDetailCollectionViewCellViewModel) {
    nameCharacterLabel.text = viewModel.characterModel?.name
    genderApiLabel.text = viewModel.characterModel?.gender
    statusApiLabel.text = viewModel.characterModel?.status
    speciesApiLabel.text = viewModel.characterModel?.species
    originApiLabel.text = viewModel.characterModel?.origin.name
    typeApiLabel.text = viewModel.characterModel?.type
    locationApiLabel.text = viewModel.characterModel?.location.name
    
    viewModel.fetchImage { [weak self] result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.characterImageView.image = UIImage(data: data)
        }
      case .failure:
        break
      }
    }
  }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CharacterDetailTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedImage = info[.originalImage] as? UIImage {
       characterImageView.image = selectedImage
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
