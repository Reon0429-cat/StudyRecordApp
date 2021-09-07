//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit

// MARK: - ToDo 今日が一番右にスクロールされるようのする
// MARK: - ToDo 編集で間を0で埋めるかどうかを選択できるようにする
// MARK: - ToDo セグメントを編集の方に移動させる
// MARK: - ToDo データがないときに、データがないよラベルを表示させる

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var myGraphView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    private var graphView: CustomScrollableGraphView!
    private var lineData = [(color: UIColor, identifier: String, xTitle: String)]()
    private var sumData = [String: Double]()
    private var beforeIdentifier = ""
    private var beforeYear = 0
    private var years = [Int]()
    private var segmentedControlSelectedIndexID = ""
    var onSegmentedControlEvent: (() -> Void)?
    
    func configure(record: Record, graph: Graph) {
        setupTitleLabel(record: record)
        segmentedControlSelectedIndexID = record.yearID
        setupSegmentedControl(record: record)
        setupGraphView()
        lineData.removeAll()
        sumData.removeAll()
        beforeYear = 0
        setupLineData(record: record, graph: graph)
        myGraphView.subviews.forEach { $0.removeFromSuperview() }
        graphView.set(to: myGraphView)
    }
    
}

// MARK: - IBAction func
private extension GraphTableViewCell {
    
    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex,
                                  forKey: segmentedControlSelectedIndexID)
        onSegmentedControlEvent?()
    }
    
}

// MARK: - CustomScrollableGraphViewDelegate
extension GraphTableViewCell: CustomScrollableGraphViewDelegate {
    
    func value(at index: Int) -> Double {
        let selectedYear = years[segmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter { $0.identifier.hasPrefix("\(selectedYear)") }
        let filteredSumData = sumData.filter { $0.key.hasPrefix("\(selectedYear)") }
        let identifier = filteredLineData[index].identifier
        guard let sumData = filteredSumData[identifier] else { return 0.0 }
        let hour = Double(sumData / 60)
        let minutes = Double(Int(sumData) % 60 / 60)
        return hour + minutes
    }
    
    func label(at index: Int) -> String {
        let selectedYear = years[segmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter { $0.identifier.hasPrefix("\(selectedYear)") }
        return filteredLineData[index].xTitle
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
    
    func setupGraphView() {
        graphView = CustomScrollableGraphView()
        graphView.delegate = self
    }
    
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
            segmentedControl.insertSegment(withTitle: "\(year)",
                                           at: index, animated: false)
        }
        let index = UserDefaults.standard.integer(forKey: segmentedControlSelectedIndexID)
        segmentedControl.selectedSegmentIndex = index
    }
    
    func setupLineData(record: Record, graph: Graph) {
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
            graphView.create(color: UIColor(record: record),
                             identifier: identifier,
                             graph: graph)
        }
    }
    
}
