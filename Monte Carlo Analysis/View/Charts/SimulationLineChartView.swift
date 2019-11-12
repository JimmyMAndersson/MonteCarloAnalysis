import UIKit
import Charts

class SimulationLineChartView: LineChartView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.sharedInit()
  }
  
  private func sharedInit() {
    self.isUserInteractionEnabled = false
    self.xAxis.labelPosition = .bottom
    self.borderLineWidth = 1.5
    self.drawBordersEnabled = true
    self.borderColor = .applynBlue
    self.noDataText = "No data available. Tap 'Simulate' to display."
    self.noDataTextColor = .warningRed
    self.legend.textColor = .white
    self.legend.textHeightMax = 16
    self.leftAxis.labelTextColor = .white
    self.leftAxis.gridColor = .applynBlue
    self.leftAxis.zeroLineColor = .applynBlue
    self.leftAxis.gridLineWidth = 0.5
    self.leftAxis.zeroLineWidth = 0.5
    self.rightAxis.drawLabelsEnabled = false
    self.rightAxis.drawGridLinesEnabled = false
    self.xAxis.labelTextColor = .white
    self.xAxis.drawLabelsEnabled = true
    self.xAxis.gridColor = .applynBlue
    self.xAxis.axisLineColor = .applynBlue
    self.xAxis.gridLineWidth = 0.5
    self.xAxis.axisLineWidth = 0.5
    self.translatesAutoresizingMaskIntoConstraints = false
    self.legend.direction = .leftToRight
    self.legend.setCustom(entries: [LegendEntry(label: "Trendline (Mean)", form: .line, formSize: 20, formLineWidth: 3, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: .white)])
  }
}
