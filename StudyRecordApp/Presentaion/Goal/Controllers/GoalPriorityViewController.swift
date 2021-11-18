//
//  GoalPriorityViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

protocol GoalPriorityVCDelegate: AnyObject {
    func addButtonDidTapped(priority: Category.Goal.Priority)
}

final class GoalPriorityViewController: UIViewController {

    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var pickerView: UIPickerView!

    weak var delegate: GoalPriorityVCDelegate?
    var inputtedPriority = Category.Goal.Priority(mark: .star, number: .one)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPickerView()
        setupSegmentedControl()
        setupAddButton()

    }

}

// MARK: - IBAction func
private extension GoalPriorityViewController {

    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        guard let mark = PriorityMark(rawValue: sender.selectedSegmentIndex) else { return }
        inputtedPriority = Category.Goal.Priority(mark: mark, number: inputtedPriority.number)
        pickerView.reloadComponent(0)
    }

    @IBAction func addButtonDidTapped(_ sender: Any) {
        delegate?.addButtonDidTapped(priority: inputtedPriority)
        dismiss(animated: true)
    }

}

// MARK: - UIPickerViewDelegate
extension GoalPriorityViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let number = PriorityNumber(rawValue: row) else { return }
        inputtedPriority = Category.Goal.Priority(mark: inputtedPriority.mark, number: number)
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let view = UIView()
        let priority = Category.Goal.Priority(mark: inputtedPriority.mark,
                                              number: PriorityNumber(rawValue: row) ?? .one)
        let priorityStackView = PriorityStackView(priority: priority)
        view.addSubview(priorityStackView)
        NSLayoutConstraint.activate([
            priorityStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            priorityStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }

}

// MARK: - UIPickerViewDataSource
extension GoalPriorityViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return PriorityNumber.allCases.count
    }

}

// MARK: - HalfModalPresenterDelegate
extension GoalPriorityViewController: HalfModalPresenterDelegate {

    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }

}

// MARK: - setup
private extension GoalPriorityViewController {

    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(inputtedPriority.number.rawValue,
                             inComponent: 0,
                             animated: true)
    }

    func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = inputtedPriority.mark.rawValue
    }

    func setupAddButton() {
        addButton.setTitle(L10n.add)
    }

}
