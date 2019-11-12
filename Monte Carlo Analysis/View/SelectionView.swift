import UIKit
import Charts

protocol SelectionViewDelegate: AnyObject {
  var games: [String] { get }
  var bets: [Int] { get }
  var rounds: [Int] { get }
  var selectedGame: Int { get }
  var selectedBet: Int { get }
  var selectedRounds: Int { get }
  func simulationRequested()
  func gameChanged(to newGame: Int)
  func betChanged(to newBet: Int)
  func roundsChanged(to newRounds: Int)
}

final class SelectionView: UIView {
  private let throbber: UIActivityIndicatorView = {
    let throbber = UIActivityIndicatorView(style: .large)
    throbber.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    throbber.color = .white
    throbber.translatesAutoresizingMaskIntoConstraints = false
    throbber.hidesWhenStopped = true
    throbber.stopAnimating()
    return throbber
  }()
  private var gamesControl = SimulatorOptionsControl()
  private var betsControl = SimulatorOptionsControl()
  private var roundsControl = SimulatorOptionsControl()
  private let gamesLabel = TitleLabel(text: "Select A Game", alignment: .center, fontSize: 18)
  private let roundsLabel = TitleLabel(text: "Select Number Of Rounds", alignment: .center, fontSize: 18)
  private let betsLabel = TitleLabel(text: "Select Amount To Bet Each Round", alignment: .center, fontSize: 18)
  private let startSimulationButton = HighlightableButton(title: "Simulate")
  private let backgroundLayer = BackgroundLayer()
  weak var delegate: SelectionViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.sharedInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.sharedInit()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.backgroundLayer.frame = self.frame
  }
  
  private func sharedInit() {
    self.backgroundColor = .applynBlue
    self.layer.addSublayer(self.backgroundLayer)
    
    let titleLabel = TitleLabel(text: "Monte Carlo Simulator", fontSize: 24)
    
    self.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
    
    self.addSubview(self.startSimulationButton)
    self.startSimulationButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    self.startSimulationButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.startSimulationButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
    self.startSimulationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    self.startSimulationButton.addTarget(self, action: #selector(simulateButtonTapped), for: .touchUpInside)
    
    self.addSubview(self.gamesLabel)
    self.gamesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 10).isActive = true
    self.gamesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10).isActive = true
    
    self.addSubview(self.gamesControl)
    self.gamesControl.leadingAnchor.constraint(equalTo: self.gamesLabel.leadingAnchor).isActive = true
    self.gamesControl.trailingAnchor.constraint(equalTo: self.gamesLabel.trailingAnchor).isActive = true
    self.gamesControl.topAnchor.constraint(equalTo: self.gamesLabel.bottomAnchor, constant: 10).isActive = true
    self.gamesControl.addTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
    
    self.addSubview(roundsLabel)
    self.roundsLabel.topAnchor.constraint(equalTo: self.gamesControl.bottomAnchor, constant: 50).isActive = true
    self.roundsLabel.leadingAnchor.constraint(equalTo: self.gamesLabel.leadingAnchor).isActive = true
    self.roundsLabel.trailingAnchor.constraint(equalTo: self.gamesLabel.trailingAnchor).isActive = true
    
    self.addSubview(self.roundsControl)
    self.roundsControl.leadingAnchor.constraint(equalTo: self.gamesLabel.leadingAnchor).isActive = true
    self.roundsControl.trailingAnchor.constraint(equalTo: self.gamesLabel.trailingAnchor).isActive = true
    self.roundsControl.topAnchor.constraint(equalTo: self.roundsLabel.bottomAnchor, constant: 10).isActive = true
    self.roundsControl.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    self.roundsControl.addTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
    
    self.addSubview(betsLabel)
    self.betsLabel.topAnchor.constraint(equalTo: self.roundsControl.bottomAnchor, constant: 50).isActive = true
    self.betsLabel.leadingAnchor.constraint(equalTo: self.gamesLabel.leadingAnchor).isActive = true
    self.betsLabel.trailingAnchor.constraint(equalTo: self.gamesLabel.trailingAnchor).isActive = true
    
    self.addSubview(self.betsControl)
    self.betsControl.leadingAnchor.constraint(equalTo: self.gamesLabel.leadingAnchor).isActive = true
    self.betsControl.trailingAnchor.constraint(equalTo: self.gamesLabel.trailingAnchor).isActive = true
    self.betsControl.topAnchor.constraint(equalTo: self.betsLabel.bottomAnchor, constant: 10).isActive = true
    self.betsControl.addTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
    
    self.addSubview(self.throbber)
    self.throbber.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    self.throbber.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    self.throbber.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    self.throbber.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
  }
  
  func tearDown() {
    self.startSimulationButton.removeTarget(self, action: #selector(simulateButtonTapped), for: .touchUpInside)
    self.gamesControl.removeTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
    self.roundsControl.removeTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
    self.betsControl.removeTarget(self, action: #selector(selectionChanged(_:)), for: .valueChanged)
  }
  
  func updateSelections() {
    self.updateSegmentedControl(self.gamesControl, with: self.delegate?.games, selection: self.delegate?.selectedGame ?? 0)
    self.updateSegmentedControl(self.betsControl, with: self.delegate?.bets, selection: self.delegate?.selectedBet ?? 0)
    self.updateSegmentedControl(self.roundsControl, with: self.delegate?.rounds, selection: self.delegate?.selectedRounds ?? 0)
  }
  
  private func updateSegmentedControl(_ control: UISegmentedControl, with values: [CustomStringConvertible]?, selection: Int) {
    guard let values = values else { return }
    
    control.removeAllSegments()
    for (index, value) in values.enumerated() {
      control.insertSegment(withTitle: value.description, at: index, animated: false)
    }
    control.selectedSegmentIndex = selection
  }
  
  @objc private func selectionChanged(_ sender: UISegmentedControl) {
    switch sender {
      case self.gamesControl:
        self.delegate?.gameChanged(to: sender.selectedSegmentIndex)
      
      case self.roundsControl:
        self.delegate?.roundsChanged(to: sender.selectedSegmentIndex)
      
      case self.betsControl:
        self.delegate?.betChanged(to: sender.selectedSegmentIndex)
      
      default:
        break
    }
  }
  
  @objc private func simulateButtonTapped() {
    self.throbber.startAnimating()
    self.delegate?.simulationRequested()
  }
}
