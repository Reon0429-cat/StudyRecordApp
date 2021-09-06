//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit
import ScrollableGraphView

// MARK: - ToDo 年度、月別にグラフを切り替えられるようにする

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var myGraphView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    
    private var graphView: ScrollableGraphView!
    private var lineData = [(color: UIColor, identifier: String, xTitle: String)]()
    private var sumData = [String: Double]()
    private var beforeIdentifier = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(record: Record) {
        titleLabel.text = record.title
        
        createGraphView()
        lineData.removeAll()
        sumData.removeAll()
        setupLineData(record: record)
        createReferenceLines()
        myGraphView.subviews.forEach { $0.removeFromSuperview() }
        myGraphView.addSubview(graphView)
        
    }
    
    private func createGraphView() {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: myGraphView.frame.width,
                           height: myGraphView.frame.height)
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.rangeMin = 24
        graphView.rangeMax = 0
        graphView.rightmostPointPadding = 20
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.topMargin = 10
        graphView.dataPointSpacing = 30
    }
    
    private func setupLineData(record: Record) {
        guard let histories = record.histories else { return }
        histories.forEach { historiy in
            let identifier = "\(historiy.year)-\(historiy.month)-\(historiy.day)"
            let data = Double(historiy.hour * 60 + historiy.minutes)
            if beforeIdentifier == identifier {
                let data = (sumData[identifier] ?? 0.0) + data
                sumData.updateValue(data, forKey: identifier)
            } else {
                sumData[identifier] = data
                beforeIdentifier = identifier
            }
            lineData.append((color: UIColor(record: record),
                             identifier: identifier,
                             xTitle: "\(historiy.month)/\(historiy.day)"))
            createLineDot(color: UIColor(record: record), identifier: identifier)
        }
    }
    
    private func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = .black
        referenceLines.includeMinMax = false
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [Int](0...24).map { Double($0) }
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
        linePlot.animationDuration = 0.1
        return linePlot
    }
    
    private func createDot(color: UIColor, identifier: String) -> DotPlot {
        let dotPlot = DotPlot(identifier: identifier)
        dotPlot.dataPointType = .circle
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.animationDuration = 0.1
        return dotPlot
    }
    
}

// MARK: - ScrollableGraphViewDataSource
extension GraphTableViewCell: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot,
               atIndex pointIndex: Int) -> Double {
        let identifier = lineData[pointIndex].identifier
        guard let sumData = sumData[identifier] else { return 0.0 }
        let hour = Double(sumData / 60)
        let minutes = Double(Int(sumData) % 60 / 60)
        return hour + minutes
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return lineData[pointIndex].xTitle
    }
    
    func numberOfPoints() -> Int {
        if sumData.isEmpty {
            return 0
        }
        return sumData.count
    }
    
}
