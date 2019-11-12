public protocol GameProtocol: Initializable {
  static var gameName: String { get }
  func playRound(bet: Double) -> GameRoundOutcome
}
