import Charts

extension LineChartDataSet {
  public func stylizeSimulation(color: UIColor, lineWidth: CGFloat = 1) {
    self.setColor(color)
    self.drawCirclesEnabled = false
    self.drawValuesEnabled = false
    self.lineWidth = lineWidth
    self.lineCapType = .round
    self.formLineWidth = 1
  }
  
  public func stylizeDistribution() {
    self.setColor(.applynBlue)
    self.drawCirclesEnabled = false
    self.drawValuesEnabled = false
    self.cubicIntensity = 0.2
    self.mode = .cubicBezier
    self.fillColor = .applynBlue
    self.drawFilledEnabled = true
    self.lineWidth = 1
    self.lineCapType = .round
    self.formLineWidth = 1
  }
}
