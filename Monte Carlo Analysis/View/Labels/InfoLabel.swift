import UIKit

class InfoLabel: UILabel {
  init(alignment: NSTextAlignment = .left, fontSize: CGFloat) {
    super.init(frame: .zero)
    sharedInit(alignment: alignment, fontSize: fontSize)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    sharedInit()
  }
  
  private func sharedInit(alignment: NSTextAlignment = .left, fontSize: CGFloat = 14) {
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    self.textColor = .white
    self.textAlignment = alignment
    self.translatesAutoresizingMaskIntoConstraints = false
    self.numberOfLines = 0
    self.setContentHuggingPriority(.defaultLow, for: .vertical)
  }
}
