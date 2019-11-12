import UIKit
import Charts

class SelectionViewController: UIViewController {
  private let simulator: SimulatorProtocol
  private let viewManager: ViewManager
  
  init(simulator: SimulatorProtocol, viewManager: ViewManager) {
    self.simulator = simulator
    self.viewManager = viewManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("\(#file) does not support instantiation from a coder object.")
  }
  
  private var typedView: SelectionView? {
    return self.view as? SelectionView
  }
  
  override func loadView() {
    self.view = SelectionView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.typedView?.delegate = self
    self.typedView?.updateSelections()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.typedView?.tearDown()
  }
  
  override var prefersStatusBarHidden: Bool { return true }
}

extension SelectionViewController: SelectionViewDelegate {
  var games: [String] { self.simulator.games }
  var bets: [Int] { self.simulator.bets }
  var rounds: [Int] { self.simulator.rounds }
  var selectedGame: Int { self.simulator.selectedGame }
  var selectedBet: Int { self.simulator.selectedBet }
  var selectedRounds: Int { self.simulator.selectedRounds }
  
  func simulationRequested() {
    self.simulator.simulate() { [weak self] simulations  in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.viewManager.transition(to: ResultsViewController(simulator: self.simulator, viewManager: self.viewManager, simulations: simulations), direction: .fromRight)
      }
    }
  }
  
  func gameChanged(to newGame: Int) {
    self.simulator.selectedGame = newGame
  }
  
  func betChanged(to newBet: Int) {
    self.simulator.selectedBet = newBet
  }
  
  func roundsChanged(to newRounds: Int) {
    self.simulator.selectedRounds = newRounds
  }
}
