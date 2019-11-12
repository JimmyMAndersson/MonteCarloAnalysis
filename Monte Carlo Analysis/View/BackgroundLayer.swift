import UIKit

class BackgroundLayer: CAShapeLayer {
  private let shapePath = UIBezierPath()
  
  override init() {
    super.init()
    self.sharedInit()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    self.sharedInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.sharedInit()
  }
  
  private func sharedInit() {
    self.fillColor = UIColor.applynBlack.cgColor
    self.shadowColor = UIColor.applynBlack.cgColor
    self.shadowOffset = .zero
    self.shadowRadius = 20
    self.shadowOpacity = 1
  }
  
  override func layoutSublayers() {
    super.layoutSublayers()
    self.shapePath.removeAllPoints()
    self.shapePath.move(to: .zero)
    self.shapePath.addLine(to: .init(x: 0, y: self.frame.maxY))
    self.shapePath.addCurve(to: .init(x: self.frame.maxX, y: 0),
                            controlPoint1: .init(x: self.frame.maxX, y: self.frame.maxY),
                            controlPoint2: .init(x: self.frame.maxX, y: self.frame.midY))
    self.shapePath.addLine(to: .init(x: self.frame.maxX, y: 0))
    self.shapePath.close()
    self.path = self.shapePath.cgPath
  }
}
