import Charts

public protocol DataSetProtocol {
  var game: String { get }
  var rounds: Double { get }
  var initialFunds: Double { get }
  var expectedValue: Double { get }
  var bet: Double { get }
  var chartData: [IChartDataSet]? { get }
  var distributionData: IChartDataSet? { get }
  var information: String { get }
}
