import UIKit
import Charts

class ResultsViewController: UIViewController {
  private let simulator: SimulatorProtocol
  private let viewManager: ViewManager
  private let simulations: DataSetProtocol
  
  init(simulator: SimulatorProtocol, viewManager: ViewManager, simulations: DataSetProtocol) {
    self.simulator = simulator
    self.viewManager = viewManager
    self.simulations = simulations
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("This initializer should not be used.")
  }
  
  private var typedView: ResultsView? {
    return self.view as? ResultsView
  }
  
  override func loadView() {
    self.view = ResultsView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.typedView?.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.typedView?.display(simulations: self.simulations)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.typedView?.tearDown()
  }
  
  override var prefersStatusBarHidden: Bool { return true }
}

extension ResultsViewController: ResultsViewDelegate {
  func prepareForNewSimulation() {
    self.viewManager.transition(to: SelectionViewController(simulator: self.simulator, viewManager: self.viewManager), direction: .fromLeft)
  }
}
