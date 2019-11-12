struct CrapsPassLineGame: GameProtocol {
  static var gameName: String { "Craps Pass Line" }
  
  func playRound(bet: Double) -> GameRoundOutcome {
    if Int.random(in: 1 ... 100) <= 50 {
      return .win(bet)
    } else {
      return .loss(bet)
    }
  }
}
