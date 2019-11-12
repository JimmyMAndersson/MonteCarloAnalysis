import UIKit

class HighlightableButton: UIButton {
  override var isHighlighted: Bool {
    didSet {
      self.backgroundColor = self.isHighlighted ? .applynPressedBlue : .applynBlue
      self.layer.shadowRadius = self.isHighlighted ? 3 : 4
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.sharedInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.sharedInit()
  }
  
  convenience init(title: String) {
    self.init(frame: .zero)
    self.setTitle(title, for: .normal)
  }
  
  convenience init(image: UIImage?) {
    self.init(frame: .zero)
    self.setImage(image, for: .normal)
  }
  
  private func sharedInit() {
    self.backgroundColor = .applynBlue
    self.setTitleColor(.white, for: .normal)
    self.setTitleColor(.lightGray, for: .highlighted)
    self.layer.shadowColor = UIColor.applynBlack.cgColor
    self.layer.shadowOffset = .zero
    self.layer.shadowRadius = 4
    self.layer.shadowOpacity = 0.7
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 2
  }
}
