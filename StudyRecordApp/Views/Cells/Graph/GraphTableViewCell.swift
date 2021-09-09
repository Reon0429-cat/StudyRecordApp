//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit

// MARK: - ToDo 年度を違うところに移動させ、表示させる月が選択できるようにする
// MARK: - ToDo データがないときに、データがないよラベルを表示させる
// MARK: - ToDo インジケーターをロード中に表示させる

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var graphBaseView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    private var graphView: CustomScrollableGraphView!
    private var indicator: UIActivityIndicatorView!
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
        years.removeAll()
        lineData.removeAll()
        sumData.removeAll()
        beforeYear = 0
        setYears(record: record)
        setupSegmentedControl(record: record)
        setupGraphView()
        setupGraphViewLayout()
        setupIndicator(record: record)
        setupIndicatorLayout()
        setupLineData(record: record, graph: graph)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.graphView.scrollToRight()
        
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

// MARK: - func
private extension GraphTableViewCell {
    
    func setYears(record: Record) {
        record.histories?.forEach { history in
            if beforeYear != history.year {
                years.append(history.year)
                beforeYear = history.year
            }
        }
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
        let index = UserDefaults.standard.integer(forKey: segmentedControlSelectedIndexID)
        segmentedControl.create(years.map { String($0) }, selectedIndex: index)
    }
    
    func setupIndicator(record: Record) {
        indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        let year = years[segmentedControl.selectedSegmentIndex]
        let filteredHistories = record.histories?.filter { $0.year == year }
        let time = min(Double(filteredHistories?.count ?? 0) * 0.15, 3)
        if time < 3 {
            indicator.startAnimating()
            indicator.backgroundColor = .white
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.indicator.stopAnimating()
                self.indicator.backgroundColor = .clear
            }
        }
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
        }
        graphView.create(color: UIColor(record: record), graph: graph)
    }
    
}

// MARK: - setup layout
extension GraphTableViewCell {
    
    func setupGraphViewLayout() {
        graphBaseView.subviews.forEach { $0.removeFromSuperview() }
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphBaseView.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: graphBaseView.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: graphBaseView.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: graphBaseView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphBaseView.trailingAnchor)
        ])
    }
    
    func setupIndicatorLayout() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        graphView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.widthAnchor.constraint(equalTo: self.widthAnchor),
            indicator.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
}
