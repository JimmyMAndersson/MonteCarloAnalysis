import UIKit
import Charts

class DistributionLineChartView: LineChartView {
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
    self.leftAxis.axisMinimum = 0
    self.translatesAutoresizingMaskIntoConstraints = false
    self.legend.enabled = false
  }
}
