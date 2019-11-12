import Charts

class Simulator: SimulatorProtocol {
  private let dataSetColors: [UIColor] = [UIColor.red.withAlphaComponent(0.25),
                                        UIColor.orange.withAlphaComponent(0.25),
                                        UIColor.green.withAlphaComponent(0.25),
                                        UIColor.magenta.withAlphaComponent(0.25),
                                        UIColor.blue.withAlphaComponent(0.25),
                                        UIColor.brown.withAlphaComponent(0.25),
                                        UIColor.purple.withAlphaComponent(0.25)]
  
  private let startingFunds = 1000.0
  private let _rounds = [10, 50, 100]
  private let _games: [GameProtocol.Type] = [RouletteGame.self, WheelOfFortuneGame.self, CrapsPassLineGame.self]
  private let _bets = [1, 5, 10]
  private let _gamblers = [2000, 1500, 1000]
  
  var games: [String] { self._games.map { $0.gameName } }
  var rounds: [Int] { self._rounds }
  var bets: [Int] { self._bets }
  
  var selectedRounds = 0
  var selectedGame = 0
  var selectedBet = 0
  
  func simulate(completion: @escaping (_ simulations: DataSetProtocol) -> ()) {
    let game = self._games[self.selectedGame]
    let bet = Double(self._bets[self.selectedBet])
    let rounds = self._rounds[self.selectedRounds]
    
    DispatchQueue.global(qos: .userInteractive).async {
      var simulations = [IChartDataSet]()
      let meanData = (0 ... rounds).map { ChartDataEntry(x: Double($0), y: 0) }
      meanData.first?.y = self.startingFunds
      var sumRounds = 0.0
      let numberOfScenarios = self._gamblers[self.selectedRounds]
      var distribution = [Int: Int]()
      
      for set in 0 ..< numberOfScenarios {
        let gameSimulator = game.init()
        var capital = self.startingFunds
        
        let chartDataSet = LineChartDataSet(entries: [ChartDataEntry(x: 0, y: capital)])
        
        for round in 1 ... rounds {
          let result = gameSimulator.playRound(bet: bet)
          
          switch result {
            case .win(let amount):
              capital += amount.magnitude
            
            case .loss(let amount):
              capital -= amount.magnitude
            
            case .tie:
              break
          }
          
          meanData[round].y += Double(capital) / Double(numberOfScenarios)
          let chartEntry = ChartDataEntry(x: Double(round), y: Double(capital))
          chartDataSet.append(chartEntry)
          
          if capital <= 0 || round == rounds {
            sumRounds += Double(round)
            break
          }
        }
        
        let roundedCapital = Int(capital.rounded(.toNearestOrAwayFromZero))
        distribution[roundedCapital, default: 0] += 1
        
        let colorIndex = set % self.dataSetColors.count
        let color = self.dataSetColors[colorIndex]
        chartDataSet.stylizeSimulation(color: color)
        simulations.append(chartDataSet)
      }
      
      let meanRounds = (sumRounds / Double(simulations.count)).rounded(.toNearestOrAwayFromZero)
      
      let meanDataSet = LineChartDataSet(entries: meanData)
      meanDataSet.stylizeSimulation(color: .white, lineWidth: 2)
      simulations.append(meanDataSet)
      
      let distributionDataSet = LineChartDataSet(entries: distribution.sorted(by: <).map { ChartDataEntry(x: Double($0.key), y: Double($0.value) / Double(numberOfScenarios)) })
      distributionDataSet.stylizeDistribution()
      
      let expectedValue = distribution.reduce(0) { $0 + Double($1.key) * Double($1.value) / Double(numberOfScenarios) }
      
      let simulationsDataSet: DataSetProtocol = SimulatorDataSet(game: game.gameName,
                                                                 rounds: meanRounds,
                                                                 initialFunds: self.startingFunds,
                                                                 expectedValue: expectedValue,
                                                                 bet: bet,
                                                                 chartData: simulations,
                                                                 distributionData: distributionDataSet)
      
      completion(simulationsDataSet)
    }
  }
}
