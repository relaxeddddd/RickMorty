import UIKit

/// Кастомные лейблы
final class CustomLabel: UILabel {
  init(text: String) {
    super.init(frame: CGRect())
    commonSetup()
    self.text = text
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonSetup()
  }
  
  private func commonSetup() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.textAlignment = .center
    self.font = .systemFont(ofSize: 16, weight: .medium)
  }
}

final class CustomAPILabel: UILabel {
  init() {
    super.init(frame: CGRect())
    commonSetup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonSetup()
  }
  
  private func commonSetup() {
    self.numberOfLines = 0
    self.translatesAutoresizingMaskIntoConstraints = false
    self.font = .systemFont(ofSize: 14)
    self.textColor = UIColor(named: "infoCharLabel")
  }
}

final class CustomCharacterAPILabel: UILabel {
  init() {
    super.init(frame: CGRect())
    commonSetup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonSetup()
  }
  
  private func commonSetup() {
    self.textColor = .secondaryLabel
    self.font = .systemFont(ofSize: 16, weight: .regular)
    self.translatesAutoresizingMaskIntoConstraints = false
  }
}

