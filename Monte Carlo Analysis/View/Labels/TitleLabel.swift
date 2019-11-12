import UIKit

class TitleLabel: UILabel {
  init(text: String, alignment: NSTextAlignment = .center, fontSize: CGFloat) {
    super.init(frame: .zero)
    sharedInit(text: text, alignment: alignment, fontSize: fontSize)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    sharedInit()
  }
  
  private func sharedInit(text: String = "", alignment: NSTextAlignment = .center, fontSize: CGFloat = 24) {
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    self.textColor = .white
    self.textAlignment = alignment
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
  }
}
