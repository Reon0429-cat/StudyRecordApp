//
//  GoalTimeViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/03.
//

import UIKit

enum GoalDateType {
    case created
    case due
}

protocol GoalTimeVCDelegate: AnyObject {
    func saveButtonDidTapped(date: Date, dateType: GoalDateType)
}

final class GoalTimeViewController: UIViewController {

    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var todayButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var contentView: UIView!

    weak var delegate: GoalTimeVCDelegate?
    var inputtedDate: Date!
    var dateType: GoalDateType!
    private var inputtedYear = DateType.year.numbers[0]
    private var inputtedMonth = DateType.month.numbers[0]
    private var inputtedDay = DateType.day.numbers[0]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerView()
        setupTodayButton()
        setupSaveButton()
        setupDismissButton()

    }

}

// MARK: - IBAction func
extension GoalTimeViewController {

    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        delegate?.saveButtonDidTapped(date: inputtedDate, dateType: dateType)
        dismiss(animated: true)
    }

    @IBAction private func todayButtonDidTapped(_ sender: Any) {
        inputtedDate = Date()
        selectRow(date: inputtedDate)
    }

    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - UIPickerViewDelegate
extension GoalTimeViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let dateType = DateType.allCases[component]
        switch dateType {
        case .year: inputtedYear = dateType.numbers[row]
        case .month: inputtedMonth = dateType.numbers[row]
        case .day: inputtedDay = dateType.numbers[row]
        default: break
        }
        let fixedDate = Date().fixed(year: inputtedYear,
                                     month: inputtedMonth,
                                     day: inputtedDay)
        inputtedDate = fixedDate
    }

}

// MARK: - UIPickerViewDataSource
extension GoalTimeViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return DateType.allCases.count - 2
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        let dateType = DateType.allCases[component]
        return dateType.numbers.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: view.heightAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        let dateType = DateType.allCases[component]
        label.text = dateType.title(row: row)
        label.textAlignment = dateType.alignment
        return view
    }

}

// MARK: - HalfModalPresenterDelegate
extension GoalTimeViewController: HalfModalPresenterDelegate {

    var halfModalContentHeight: CGFloat {
        return self.contentView.frame.height
    }

}

// MARK: - setup
private extension GoalTimeViewController {

    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        selectRow(date: inputtedDate)
    }

    func selectRow(date: Date) {
        inputtedYear = date.year
        inputtedMonth = date.month
        inputtedDay = date.day
        let selectingRowsAndComponents: [(row: Int, component: Int)] = [
            (row: DateType.year.numbers.firstIndex(of: inputtedYear) ?? 0,
             component: DateType.year.component),
            (row: DateType.month.numbers.firstIndex(of: inputtedMonth) ?? 0,
             component: DateType.month.component),
            (row: DateType.day.numbers.firstIndex(of: inputtedDay) ?? 0,
             component: DateType.day.component)
        ]
        selectingRowsAndComponents.forEach {
            pickerView.selectRow($0.row, inComponent: $0.component, animated: true)
        }
    }

    func setupTodayButton() {
        todayButton.setTitle(L10n.today)
    }

    func setupSaveButton() {
        saveButton.setTitle(L10n.save)
    }

    func setupDismissButton() {
        dismissButton.setTitle(L10n.close)
    }

}
