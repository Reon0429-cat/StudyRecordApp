//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit
import ScrollableGraphView

// MARK: - ToDo 今日が一番右にスクロールされるようのする
// MARK: - ToDo 編集で間を0で埋めるかどうかを選択できるようにする
// MARK: - ToDo セグメントを編集の方に移動させる
// MARK: - ToDo セグメントを共通化する
// MARK: - ToDo データがないときに、データがないよラベルを表示させる

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var myGraphView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private var graphView: ScrollableGraphView!
    private var lineData = [(color: UIColor, identifier: String, xTitle: String)]()
    private var sumData = [String: Double]()
    private var beforeIdentifier = ""
    private var beforeYear = 0
    private var years = [Int]()
    private var segmentedControlSelectedIndexID = ""
    var onSegmentedControlEvent: (() -> Void)?
    
    func configure(record: Record) {
        setupTitleLabel(record: record)
        segmentedControlSelectedIndexID = record.yearID
        setupSegmentedControl(record: record)
        createGraphView()
        lineData.removeAll()
        sumData.removeAll()
        beforeYear = 0
        setupLineData(record: record)
        createReferenceLines()
        myGraphView.subviews.forEach { $0.removeFromSuperview() }
        myGraphView.addSubview(graphView)
    }
    
    @IBAction private func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: segmentedControlSelectedIndexID)
        onSegmentedControlEvent?()
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
        let selectedYear = years[segmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter { $0.identifier.hasPrefix("\(selectedYear)") }
        let filteredSumData = sumData.filter { $0.key.hasPrefix("\(selectedYear)") }
        let identifier = filteredLineData[pointIndex].identifier
        guard let sumData = filteredSumData[identifier] else { return 0.0 }
        let hour = Double(sumData / 60)
        let minutes = Double(Int(sumData) % 60 / 60)
        return hour + minutes
    }
    
    func label(atIndex pointIndex: Int) -> String {
        let selectedYear = years[segmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter { $0.identifier.hasPrefix("\(selectedYear)") }
        return filteredLineData[pointIndex].xTitle
    }
    
    func numberOfPoints() -> Int {
        if sumData.isEmpty {
            return 0
        }
        guard segmentedControl.selectedSegmentIndex != -1 else { return 0 }
        let selectedYear = years[segmentedControl.selectedSegmentIndex]
        let filteredSumData = sumData.filter { $0.key.hasPrefix("\(selectedYear)") }
        return filteredSumData.count
    }
    
}

// MARK: - setup
private extension GraphTableViewCell {
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupSegmentedControl(record: Record) {
        years.removeAll()
        record.histories?.forEach { history in
            if beforeYear != history.year {
                years.append(history.year)
                beforeYear = history.year
            }
        }
        segmentedControl.removeAllSegments()
        years.enumerated().forEach { index, year in
            segmentedControl.insertSegment(withTitle: "\(year)", at: index, animated: false)
        }
        let index = UserDefaults.standard.integer(forKey: segmentedControlSelectedIndexID)
        segmentedControl.selectedSegmentIndex = index
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                                for: .selected)
        segmentedControl.selectedSegmentTintColor = .black
    }
    
    func setupLineData(record: Record) {
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
    
}
