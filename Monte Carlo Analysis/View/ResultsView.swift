import UIKit
import Charts

protocol ResultsViewDelegate: AnyObject {
  func prepareForNewSimulation()
}

final class ResultsView: UIView {
  private let scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.isScrollEnabled = true
    scroll.showsVerticalScrollIndicator = true
    scroll.showsHorizontalScrollIndicator = false
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  private let arrowImage = UIImage(named: "back-arrow")
  private let simulationsChart = SimulationLineChartView()
  private let distributionChart = DistributionLineChartView()
  private let infoLabel = InfoLabel(fontSize: 13)
  private let resetSimulationButton = HighlightableButton()
  private let backgroundLayer = BackgroundLayer()
  weak var delegate: ResultsViewDelegate?
  
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
    self.scrollView.contentSize = .init(width: self.frame.width, height: self.infoLabel.frame.maxY + self.frame.height - self.resetSimulationButton.frame.minY + 20)
    self.distributionChart.fitScreen()
    self.simulationsChart.fitScreen()
  }
  
  private func sharedInit() {
    self.backgroundColor = .applynBlue
    self.layer.addSublayer(self.backgroundLayer)
    self.resetSimulationButton.setImage(self.arrowImage, for: .normal)
    
    self.addSubview(self.scrollView)
    scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
    let simulationsTitleLabel = TitleLabel(text: "Simulations", alignment: .left, fontSize: 24)
    scrollView.addSubview(simulationsTitleLabel)
    simulationsTitleLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 15).isActive = true
    simulationsTitleLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
    simulationsTitleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
    simulationsTitleLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20).isActive = true
    
    scrollView.addSubview(self.simulationsChart)
    self.simulationsChart.topAnchor.constraint(equalTo: simulationsTitleLabel.bottomAnchor, constant: 10).isActive = true
    self.simulationsChart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
    self.simulationsChart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
    self.simulationsChart.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true
    
    let distributionsTitleLabel = TitleLabel(text: "Final Funds Distribution", alignment: .left, fontSize: 24)
    scrollView.addSubview(distributionsTitleLabel)
    distributionsTitleLabel.topAnchor.constraint(equalTo: self.simulationsChart.bottomAnchor, constant: 15).isActive = true
    distributionsTitleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    distributionsTitleLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
    distributionsTitleLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20).isActive = true
    
    scrollView.addSubview(self.distributionChart)
    self.distributionChart.topAnchor.constraint(equalTo: distributionsTitleLabel.bottomAnchor, constant: 10).isActive = true
    self.distributionChart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
    self.distributionChart.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15).isActive = true
    self.distributionChart.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15).isActive = true
    
    let simulationStatsLabel = TitleLabel(text: "Simulation Stats", alignment: .left, fontSize: 24)
    scrollView.addSubview(simulationStatsLabel)
    simulationStatsLabel.topAnchor.constraint(equalTo: self.distributionChart.bottomAnchor, constant: 15).isActive = true
    simulationStatsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    simulationStatsLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
    simulationStatsLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20).isActive = true
    
    scrollView.addSubview(self.infoLabel)
    self.infoLabel.topAnchor.constraint(equalTo: simulationStatsLabel.bottomAnchor, constant: 10).isActive = true
    self.infoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    self.infoLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
    self.infoLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20).isActive = true
    
    self.addSubview(self.resetSimulationButton)
    self.resetSimulationButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    self.resetSimulationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
    self.resetSimulationButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    self.resetSimulationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    self.resetSimulationButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
  }
  
  func tearDown() {
    self.resetSimulationButton.removeTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
  }
  
  @objc private func resetButtonTapped() {
    self.delegate?.prepareForNewSimulation()
  }
  
  func display(simulations: DataSetProtocol) {
    let simulationData = LineChartData(dataSets: simulations.chartData)
    self.simulationsChart.data = simulationData
    
    let distributionData = LineChartData(dataSet: simulations.distributionData)
    self.distributionChart.data = distributionData
    
    self.infoLabel.text = simulations.information
  }
}
