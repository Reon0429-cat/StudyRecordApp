//
//  GraphTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/04.
//

import UIKit

protocol GraphTableViewCellDelegate: AnyObject {
    func segmentedControlDidTapped(index: Int)
    func registerButtonDidTapped(index: Int)
}

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var graphBaseView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var yearSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var monthSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var yAxisLabel: UILabel!
    @IBOutlet private weak var noGraphDataLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!
    
    private var graphView: CustomScrollableGraphView!
    private var indicator: UIActivityIndicatorView!
    private var lineData = [(color: UIColor, identifier: String, xTitle: String)]()
    private var sumData = [String: Double]()
    private var beforeIdentifier = ""
    private var beforeYear = 0
    private var years = [Int]()
    private var yearSegmentedControlID = ""
    private var beforeMonth = 0
    private var months = [Int]()
    private var monthSegmentedControlID = ""
    private var simpleNoGraphDataLabel = UILabel()
    
    weak var delegate: GraphTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func configure(record: Record, graph: Graph) {
        setupTitleLabel(record: record)
        yearSegmentedControlID = record.yearID
        monthSegmentedControlID = record.monthID
        years.removeAll()
        months.removeAll()
        lineData.removeAll()
        sumData.removeAll()
        setupGraphBaseView()
        setYears(record: record)
        setMonths(record: record)
        setupYearSegmentedControl(record: record)
        setupMonthSegmentedControl(record: record)
        setupGraphView()
        setupGraphViewLayout()
        setupIndicator(record: record)
        setupIndicatorLayout()
        setupLineData(record: record, graph: graph)
        setupIfNoGraphData(record: record)
        setupRegisterButton()
        setupSimpleNoGraphDataLabel()
        setupSimpleNoGraphDataLabelLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.graphView.scrollToRight()
        
    }
    
}

// MARK: - IBAction func
private extension GraphTableViewCell {
    
    @IBAction func yearSegmentedControlDidSelected(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex,
                                  forKey: yearSegmentedControlID)
        delegate?.segmentedControlDidTapped(index: self.tag)
        setLabelIfNoData()
    }
    
    @IBAction func monthSegmentedControlDidSelected(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex,
                                  forKey: monthSegmentedControlID)
        delegate?.segmentedControlDidTapped(index: self.tag)
        setLabelIfNoData()
    }
    
    @IBAction func registerButtonDidTapped(_ sender: Any) {
        delegate?.registerButtonDidTapped(index: self.tag)
    }
}

// MARK: - func
private extension GraphTableViewCell {
    
    func setYears(record: Record) {
        beforeYear = 0
        record.histories?.forEach { history in
            if beforeYear != history.year {
                years.append(history.year)
                beforeYear = history.year
            }
        }
    }
    
    func setMonths(record: Record) {
        beforeMonth = 0
        record.histories?.forEach { history in
            if beforeMonth != history.month {
                months.append(history.month)
                beforeMonth = history.month
            }
        }
    }
    
    func setLabelIfNoData() {
        let year: Int = {
            if years.isEmpty {
                return 0
            }
            return years[yearSegmentedControl.selectedSegmentIndex]
        }()
        let month: Int = {
            if months.isEmpty {
                return 0
            }
            return months[monthSegmentedControl.selectedSegmentIndex]
        }()
        let filteredSumData = sumData.filter {
            $0.key.hasPrefix("\(year)-\(month)")
        }
        if filteredSumData.isEmpty {
            simpleNoGraphDataLabel.isHidden = false
        } else {
            simpleNoGraphDataLabel.isHidden = true
        }
    }
    
}

// MARK: - CustomScrollableGraphViewDelegate
extension GraphTableViewCell: CustomScrollableGraphViewDelegate {
    
    func value(at index: Int) -> Double {
        let selectedYear = years[yearSegmentedControl.selectedSegmentIndex]
        let selectedMonth = months[monthSegmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter {
            $0.identifier.hasPrefix("\(selectedYear)-\(selectedMonth)")
        }
        let filteredSumData = sumData.filter {
            $0.key.hasPrefix("\(selectedYear)-\(selectedMonth)")
        }
        let identifier = filteredLineData[index].identifier
        guard let sumData = filteredSumData[identifier] else { return 0.0 }
        let hour = Double(sumData / 60)
        let minutes = Double(Int(sumData) % 60 / 60)
        return hour + minutes
    }
    
    func label(at index: Int) -> String {
        let selectedYear = years[yearSegmentedControl.selectedSegmentIndex]
        let selectedMonth = months[monthSegmentedControl.selectedSegmentIndex]
        let filteredLineData = lineData.filter {
            $0.identifier.hasPrefix("\(selectedYear)-\(selectedMonth)")
        }
        return filteredLineData[index].xTitle
    }
    
    func numberOfPoints() -> Int {
        if sumData.isEmpty {
            return 0
        }
        guard yearSegmentedControl.selectedSegmentIndex != -1 else { return 0 }
        let selectedYear = years[yearSegmentedControl.selectedSegmentIndex]
        let selectedMonth = months[monthSegmentedControl.selectedSegmentIndex]
        let filteredSumData = sumData.filter {
            $0.key.hasPrefix("\(selectedYear)-\(selectedMonth)")
        }
        return filteredSumData.count
    }
    
}

// MARK: - setup
private extension GraphTableViewCell {
    
    func setupGraphView() {
        graphView = CustomScrollableGraphView()
        graphView.delegate = self
    }
    
    func setupGraphBaseView() {
        graphBaseView.layer.borderColor = UIColor.black.cgColor
        graphBaseView.layer.borderWidth = 2
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupYearSegmentedControl(record: Record) {
        let index = UserDefaults.standard.integer(forKey: yearSegmentedControlID)
        yearSegmentedControl.create(years.map { String($0) }, selectedIndex: index)
    }
    
    func setupMonthSegmentedControl(record: Record) {
        let index = UserDefaults.standard.integer(forKey: monthSegmentedControlID)
        monthSegmentedControl.create(months.map { String($0) }, selectedIndex: index)
    }
    
    func setupIndicator(record: Record) {
        indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        let year: Int = {
            if years.isEmpty {
                return 0
            }
            return years[yearSegmentedControl.selectedSegmentIndex]
        }()
        let month: Int = {
            if months.isEmpty {
                return 0
            }
            return months[monthSegmentedControl.selectedSegmentIndex]
        }()
        let filteredHistories = record.histories?.filter { $0.year == year && $0.month == month }
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
    
    
    func setupRegisterButton() {
        registerButton.layer.cornerRadius = 10
    }
    
    func setupIfNoGraphData(record: Record) {
        if record.histories?.isEmpty ?? true {
            noGraphDataLabel.isHidden = false
            registerButton.isHidden = false
            yAxisLabel.isHidden = true
            simpleNoGraphDataLabel.isHidden = true
        } else {
            noGraphDataLabel.isHidden = true
            registerButton.isHidden = true
            yAxisLabel.isHidden = false
            simpleNoGraphDataLabel.isHidden = false
            setLabelIfNoData()
        }
    }
    
    func setupSimpleNoGraphDataLabel() {
        simpleNoGraphDataLabel.text = "データがありません"
    }
    
}

// MARK: - setup layout
extension GraphTableViewCell {
    
    func setupGraphViewLayout() {
        graphBaseView.subviews.forEach { $0.removeFromSuperview() }
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphBaseView.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: graphBaseView.topAnchor, constant: 10),
            graphView.bottomAnchor.constraint(equalTo: graphBaseView.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: graphBaseView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphBaseView.trailingAnchor)
        ])
    }
    
    func setupIndicatorLayout() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        graphView.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: graphBaseView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.widthAnchor.constraint(equalTo: self.widthAnchor),
            indicator.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    func setupSimpleNoGraphDataLabelLayout() {
        simpleNoGraphDataLabel.translatesAutoresizingMaskIntoConstraints = false
        graphView.addSubview(simpleNoGraphDataLabel)
        NSLayoutConstraint.activate([
            simpleNoGraphDataLabel.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
            simpleNoGraphDataLabel.centerYAnchor.constraint(equalTo: graphView.centerYAnchor)
        ])
    }
    
}



