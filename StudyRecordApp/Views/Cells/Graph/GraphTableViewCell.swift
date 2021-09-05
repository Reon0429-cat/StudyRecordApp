//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit
import ScrollableGraphView

// MARK: - ToDo 同じ時間のものはまとめてグラフにする

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var myGraphView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    
    private var lines = [(color: UIColor, identifier: String, data: [Double])]()
    private var dataPointLabelTexts = [String]()
    private var graphView: ScrollableGraphView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(record: Record) {
        titleLabel.text = record.title
        
        createGraphView()
        lines.removeAll()
        dataPointLabelTexts.removeAll()
        guard let histories = record.histories else { return }
        histories.forEach { historiy in
            let identifier = "\(historiy.year)-\(historiy.month)-\(historiy.day)"
            let data = histories.map { Double($0.hour * 60 + $0.minutes) }
            lines.append((color: UIColor(record: record),
                          identifier: identifier,
                          data: data))
            dataPointLabelTexts.append("\(historiy.month)/\(historiy.day)")
            createLineDot(color: UIColor(record: record), identifier: identifier)
        }
        createReferenceLines()
        myGraphView.subviews.forEach { $0.removeFromSuperview() }
        myGraphView.addSubview(graphView)
    }
    
    private func createGraphView() {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: myGraphView.frame.width - myGraphViewRightConstraint.constant * 2,
                           height: myGraphView.frame.height)
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.delegate = self
        graphView.rangeMin = 24
        graphView.rangeMax = 0
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.topMargin = 10
        graphView.dataPointSpacing = 30
    }
    
    private func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = .black
        referenceLines.includeMinMax = false
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [Int](0...24).map { Double($0) }
        referenceLines.referenceLineUnits = "時間"
        referenceLines.shouldAddUnitsToIntermediateReferenceLineLabels = true
        referenceLines.shouldShowReferenceLineUnits = true
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    
    private func createLineDot(color: UIColor, identifier: String) {
        let linePlot = createLine(color: color, identifier: identifier)
        let dotPlot = createDot(color: color, identifier: identifier)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
    }
    
    private func createLine(color: UIColor, identifier: String) -> LinePlot {
        let linePlot = LinePlot(identifier: identifier)
        linePlot.lineColor = color
        linePlot.adaptAnimationType = .easeOut
        linePlot.animationDuration = 0.2
        return linePlot
    }
    
    private func createDot(color: UIColor, identifier: String) -> DotPlot {
        let dotPlot = DotPlot(identifier: identifier)
        dotPlot.dataPointType = .circle
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.animationDuration = 0.2
        return dotPlot
    }
    
}

// MARK: - UIScrollViewDelegate
extension GraphTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollableGraphView = scrollView as? ScrollableGraphView
    }
    
}

// MARK: - ScrollableGraphViewDataSource
extension GraphTableViewCell: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot,
               atIndex pointIndex: Int) -> Double {
        for line in lines where plot.identifier == line.identifier {
            let data = Int(line.data[pointIndex])
            let hour = Double(data / 60)
            let minutes = Double(data % 60) / 60
            return hour + minutes
        }
        return 0.0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return dataPointLabelTexts[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        if lines.isEmpty {
            return 0
        }
        return lines[0].data.count
    }
    
}

