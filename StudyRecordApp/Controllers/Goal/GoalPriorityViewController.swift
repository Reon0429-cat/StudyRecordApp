//
//  GoalPriorityViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

protocol GoalPriorityVCDelegate: AnyObject {
    
}

final class GoalPriorityViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    weak var delegate: GoalPriorityVCDelegate?
    private var priority = Priority(mark: .star, number: .one)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        
    }
    
}

// MARK: - IBAction func
private extension GoalPriorityViewController {
    
    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        guard let mark = PriorityMark(rawValue: sender.selectedSegmentIndex) else { return }
        priority = Priority(mark: mark, number: priority.number)
        pickerView.reloadComponent(0)
    }
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 追加処理
        print(priority.mark, priority.number)
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerViewDelegate
extension GoalPriorityViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let number = PriorityNumber(rawValue: row) else { return }
        priority = Priority(mark: priority.mark, number: number)
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let view = UIView()
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        (0...row).forEach { _ in
            let imageView = UIImageView()
            imageView.tintColor = .black
            imageView.preferredSymbolConfiguration = .init(pointSize: 20)
            imageView.image = priority.mark.image
            stackView.addArrangedSubview(imageView)
        }
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    }
    
}
