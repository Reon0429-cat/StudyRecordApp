//
//  StudyRecordTimeRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/10.
//

import UIKit

protocol StudyRecordTimeRecordVCDelegate: AnyObject {
    func saveButtonDidTapped(hour: Int, minutes: Int, date: String)
}

final class StudyRecordTimeRecordViewController: UIViewController {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    private let hours = [Int](0...23)
    private let minutes = [Int](0...59)
    private var selectedDate = ""
    private var selectedHour = 0
    private var selectedMinutes = 0
    var delegate: StudyRecordTimeRecordVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
        setupPickerView()
        
    }
    
    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        selectedDate = convertStringFrom(datePicker.date)
        delegate?.saveButtonDidTapped(hour: selectedHour,
                                      minutes: selectedMinutes,
                                      date: selectedDate)
        dismiss(animated: true, completion: nil)
    }
    
    static func instantiate() -> StudyRecordTimeRecordViewController {
        let storyboard = UIStoryboard(name: "StudyRecordTimeRecord", bundle: nil)
        let studyRecordTimeRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! StudyRecordTimeRecordViewController
        return studyRecordTimeRecordVC
    }
    
}

private extension StudyRecordTimeRecordViewController {
    
    func convertStringFrom(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
    
}

// MARK: - setup
private extension StudyRecordTimeRecordViewController {
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}

extension StudyRecordTimeRecordViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch component {
            case 0: return "\(hours[row])時間"
            case 1: return "\(minutes[row])分"
            default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch component {
            case 0: selectedHour = row
            case 1: selectedMinutes = row
            default: fatalError()
        }
    }
    
}

extension StudyRecordTimeRecordViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0: return hours.count
            case 1: return minutes.count
            default: fatalError()
        }
    }
    
}
