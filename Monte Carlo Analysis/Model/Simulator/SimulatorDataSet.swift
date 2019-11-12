import Charts

struct SimulatorDataSet: DataSetProtocol {
  static private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.generatesDecimalNumbers = true
    formatter.groupingSeparator = ","
    formatter.decimalSeparator = "."
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    return formatter
  }()
  
  let game: String
  let rounds: Double
  let initialFunds: Double
  let expectedValue: Double
  let bet: Double
  let chartData: [IChartDataSet]?
  let distributionData: IChartDataSet?
  let information: String
  
  init(game: String, rounds: Double, initialFunds: Double, expectedValue: Double, bet: Double, chartData: [IChartDataSet], distributionData: IChartDataSet) {
    self.game = game
    self.rounds = rounds
    self.initialFunds = initialFunds
    self.expectedValue = expectedValue
    self.bet = bet
    
    let difference = (expectedValue - initialFunds) / rounds
    let lostMoney = difference < 0
    
    if
      let formattedRounds = SimulatorDataSet.numberFormatter.string(from: NSNumber(value: rounds)),
      let formattedStartingFunds = SimulatorDataSet.numberFormatter.string(from: NSNumber(value: initialFunds)),
      let formattedBet = SimulatorDataSet.numberFormatter.string(from: NSNumber(value: bet)),
      let averageDifferencePerRound = SimulatorDataSet.numberFormatter.string(from: NSNumber(value: difference.magnitude)),
      let formattedExpectedValue = SimulatorDataSet.numberFormatter.string(from: NSNumber(value: expectedValue))
    {
      self.chartData = chartData
      self.distributionData = distributionData
      
      self.information = """
      You simulated \(chartData.count - 1) gamblers playing \(formattedRounds) rounds of \(game) each. They all started with $\(formattedStartingFunds) and bet $\(formattedBet) each round.
      
      The trendline in the first chart shows us the collective remaining funds of all gamblers after each round. It also indicates that, on average, each gambler \(lostMoney ? "lost" : "won") \(difference.magnitude < 0.01 ? "less than a cent" : "about $\(averageDifferencePerRound)") per round.
      
      The distribution chart tells us that you can expect to walk away with around $\(formattedExpectedValue) if you play this game under these circumstances.
      """
    }
    else {
      self.chartData = .none
      self.distributionData = .none
      
      self.information = "The simulation statistics could not be calculated. Select a new game and try again."
    }
  }
}
