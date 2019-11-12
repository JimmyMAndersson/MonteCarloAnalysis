import Charts

public protocol SimulatorProtocol: AnyObject {
  var rounds: [Int] { get }
  var games: [String] { get }
  var bets: [Int] { get }
  var selectedRounds: Int { get set }
  var selectedGame: Int { get set }
  var selectedBet: Int { get set }
  func simulate(completion: @escaping (_ simulations: DataSetProtocol) -> ())
}
