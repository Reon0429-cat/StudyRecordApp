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

// MARK: - ToDo 月のセグメントにはAllを追加する

final class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var graphBaseView: UIView!
    @IBOutlet private weak var myGraphViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var yearSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var monthSegmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var yAxisLabel: UILabel!
    @IBOutlet private weak var noGraphDataLabel: UILabel!
    @IBOutlet private weak var registerButton: CustomButton!
    
    private var graphView: CustomScrollableGraphView!
    private var indicator: UIActivityIndicatorView!
    private var lineData = [(color: UIColor, identifier: String, xTitle: String)]()
    private var sumData = [String: Double]()
    private var beforeIdentifier = ""
    private var years = [Int]()
    private var yearSegmentedControlID = ""
    private var months = [Int]()
    private var monthSegmentedControlID = ""
    private var simpleNoGraphDataLabel = UILabel()
    private var selectedYear: Int {
        if years.isEmpty {
            return 0
        }
        return years[yearSegmentedControl.selectedSegmentIndex]
    }
    private var selectedMonth: Int {
        if months.isEmpty {
            return 0
        }
        return months[monthSegmentedControl.selectedSegmentIndex]
    }
    private var filteredLineData: [(color: UIColor, identifier: String, xTitle: String)] {
        lineData.filter { $0.identifier.hasPrefix("\(selectedYear)-\(selectedMonth)-") }
    }
    private var filteredSumData: [String: Double] {
        sumData.filter { $0.key.hasPrefix("\(selectedYear)-\(selectedMonth)-") }
    }
    weak var delegate: GraphTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func configure(record: Record, graph: Graph) {
        years.removeAll()
        months.removeAll()
        lineData.removeAll()
        sumData.removeAll()
        setupTitleLabel(record: record)
        yearSegmentedControlID = record.yearID
        monthSegmentedControlID = record.monthID
        setupGraphBaseView()
        setupBeforeYearAndMonth(record: record)
        setupSegmentedControl(record: record)
        setupGraphView()
        setupIndicator(record: record)
        setupLineData(record: record, graph: graph)
        setupIfNoGraphData(record: record)
        setupSimpleNoGraphDataLabel()
        setupYAxisLabel()
        setupRegisterButton()
        setupNoGraphDataLabel()
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
        simpleNoGraphDataLabel(isHidden: !filteredSumData.isEmpty)
    }
    
    @IBAction func monthSegmentedControlDidSelected(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex,
                                  forKey: monthSegmentedControlID)
        delegate?.segmentedControlDidTapped(index: self.tag)
        simpleNoGraphDataLabel(isHidden: !filteredSumData.isEmpty)
    }
    
    @IBAction func registerButtonDidTapped(_ sender: Any) {
        delegate?.registerButtonDidTapped(index: self.tag)
    }
    
}

// MARK: - func
private extension GraphTableViewCell {
    
    func setupBeforeYearAndMonth(record: Record) {
        record.histories?.forEach { history in
            if !years.contains(history.year) {
                years.append(history.year)
                years.sort(by: <)
            }
            if !months.contains(history.month) {
                months.append(history.month)
                months.sort(by: <)
            }
        }
    }
    
    func simpleNoGraphDataLabel(isHidden: Bool) {
        simpleNoGraphDataLabel.isHidden = isHidden
    }
    
}

// MARK: - CustomScrollableGraphViewDelegate
extension GraphTableViewCell: CustomScrollableGraphViewDelegate {
    
    func value(at index: Int) -> Double {
        let identifier = filteredLineData[index].identifier
        guard let sumData = filteredSumData[identifier] else { return 0.0 }
        let hour = Double(sumData / 60)
        let minutes = Double(Int(sumData) % 60 / 60)
        return hour + minutes
    }
    
    func label(at index: Int) -> String {
        return filteredLineData[index].xTitle
    }
    
    func numberOfPoints() -> Int {
        guard !sumData.isEmpty,
              yearSegmentedControl.selectedSegmentIndex != -1,
              monthSegmentedControl.selectedSegmentIndex != -1 else { return 0 }
        return filteredSumData.count
    }
    
}

// MARK: - setup
private extension GraphTableViewCell {
    
    func setupGraphView() {
        graphView = CustomScrollableGraphView()
        graphView.delegate = self
        graphView.layer.cornerRadius = 10
        setupGraphViewLayout()
    }
    
    func setupGraphBaseView() {
        graphBaseView.backgroundColor = .dynamicColor(light: .white,
                                                      dark: .secondarySystemGroupedBackground)
        graphBaseView.layer.cornerRadius = 10
        graphBaseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                     dark: .accentColor ?? .white),
                                radius: 3,
                                opacity: 0.8,
                                size: (width: 2, height: 2))
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupSegmentedControl(record: Record) {
        let yearIndex = UserDefaults.standard.integer(forKey: yearSegmentedControlID)
        yearSegmentedControl.create(years.map { String($0) }, selectedIndex: yearIndex)
        let monthIndex = UserDefaults.standard.integer(forKey: monthSegmentedControlID)
        monthSegmentedControl.create(months.map { String($0) }, selectedIndex: monthIndex)
    }
    
    func setupIndicator(record: Record) {
        indicator = UIActivityIndicatorView()
        indicator.layer.cornerRadius = 10
        indicator.style = .large
        indicator.color = .dynamicColor(light: .black,
                                        dark: .white)
        let filteredHistories = record.histories?.filter {
            $0.year == selectedYear && $0.month == selectedMonth
        }
        let time = min(Double(filteredHistories?.count ?? 0) * 0.15, 3)
        if time < 3 {
            indicator.startAnimating()
            indicator.backgroundColor = .dynamicColor(light: .white,
                                                      dark: .black)
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.indicator.stopAnimating()
                self.indicator.backgroundColor = .clear
            }
        }
        setupIndicatorLayout()
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
            simpleNoGraphDataLabel(isHidden: !filteredSumData.isEmpty)
        }
    }
    
    func setupSimpleNoGraphDataLabel() {
        simpleNoGraphDataLabel.text = L10n.thereIsNoData
        setupSimpleNoGraphDataLabelLayout()
    }
    
    func setupYAxisLabel() {
        yAxisLabel.text = L10n.hour
    }
    
    func setupRegisterButton() {
        registerButton.setTitle(L10n.register)
    }
    
    func setupNoGraphDataLabel() {
        noGraphDataLabel.text = L10n.graphDataIsNotRegistered
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
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            indicator.heightAnchor.constraint(equalToConstant: 300),
            indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
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



