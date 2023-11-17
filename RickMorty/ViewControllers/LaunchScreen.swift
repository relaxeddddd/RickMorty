import UIKit

/// LaunchScreen with Animation
final class LaunchScreen: UIViewController {
  
  // MARK: - Private properties
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logo")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let animationPortal: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "portal")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad(){
    super.viewDidLoad()
    view.addSubview(logoImageView)
    view.addSubview(animationPortal)
    setConstaints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    animationPortal.center = view.center
    DispatchQueue.main.asyncAfter(deadline: .now(), execute: { self.animate() })
    
  }
  
  // MARK: - Private func
  
  private func setConstaints() {
    logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    logoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    
    animationPortal.heightAnchor.constraint(equalToConstant: 300).isActive = true
    animationPortal.widthAnchor.constraint(equalToConstant: 300).isActive = true
  }
  
  private func animate(){
    UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: {
      self.animationPortal.transform = CGAffineTransform(rotationAngle: .pi)
    }) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        let home = TabBarViewController()
        home.modalTransitionStyle = .crossDissolve
        home.modalPresentationStyle = .fullScreen
        self.present(home, animated: true)
      })
    }
  }
}
