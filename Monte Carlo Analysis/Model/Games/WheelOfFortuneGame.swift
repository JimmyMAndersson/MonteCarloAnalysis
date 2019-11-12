struct WheelOfFortuneGame: GameProtocol {
  static var gameName: String { "Big Six Wheel" }
  
  func playRound(bet: Double) -> GameRoundOutcome {
    if Int.random(in: 1 ... 100) <= 39 {
      return .win(bet)
    } else {
      return .loss(bet)
    }
  }
}
