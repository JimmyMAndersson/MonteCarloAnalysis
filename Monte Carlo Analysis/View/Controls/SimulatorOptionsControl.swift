import UIKit

class SimulatorOptionsControl: UISegmentedControl {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.sharedInit()
  }
  
  override init(items: [Any]?) {
    super.init(items: items)
    self.sharedInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.sharedInit()
  }
  
  private func sharedInit() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.tintColor = .white
    self.selectedSegmentTintColor = .applynBlue
    self.backgroundColor = UIColor.applynBlack
    self.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.borderWidth = 1
    self.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .normal)
  }
}
