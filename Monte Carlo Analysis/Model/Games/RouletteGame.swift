struct RouletteGame: GameProtocol {
  static var gameName: String { "Roulette" }
  
  func playRound(bet: Double) -> GameRoundOutcome {
    if Int.random(in: 1 ... 38) <= 18 {
      return .win(bet)
    } else {
      return .loss(bet)
    }
  }
}
