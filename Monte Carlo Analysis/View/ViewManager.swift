import UIKit

class ViewManager {
  let window: UIWindow?
  
  init(mainWindow: UIWindow?) {
    self.window = mainWindow
  }
  
  public func transition(to viewController: UIViewController, transitionType: CATransitionType = .push, direction: CATransitionSubtype) {
    guard let window = self.window else { return }
    
    let transition = CATransition()
    transition.type = transitionType
    transition.subtype = direction
    transition.duration = 0.2
    
    window.layer.add(transition, forKey: .none)
    window.rootViewController = viewController
  }
}
