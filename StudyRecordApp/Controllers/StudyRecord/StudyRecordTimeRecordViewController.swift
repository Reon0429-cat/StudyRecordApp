//
//  StudyRecordTimeRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/10.
//

import UIKit

protocol StudyRecordTimeRecordVCDelegate: AnyObject {
    func saveButtonDidTapped(history: History)
    func deleteButtonDidTapped(index: Int)
    func editButtonDidTapped(index: Int, history: History)
}

final class StudyRecordTimeRecordViewController: UIViewController {
    
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    
    private let years = [Int](2020...2030)
    private let months = [Int](1...12)
    private let days = [Int](1...31)
    private let hours = [Int](0...23)
    private let minutes = [Int](0...59)
    var history: History?
    var isHistoryDidTapped: Bool!
    var tappedHistoryIndex: Int?
    weak var delegate: StudyRecordTimeRecordVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        deleteButton.isHidden = !isHistoryDidTapped
        
    }
    
    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        if isHistoryDidTapped {
            delegate?.editButtonDidTapped(index: tappedHistoryIndex!, history: history!)
        } else {
            delegate?.saveButtonDidTapped(history: history!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func deleteButtonDidTapped(_ sender: Any) {
        let alert = UIAlertController(title: "本当に削除しますか",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            self.delegate?.deleteButtonDidTapped(index: self.tappedHistoryIndex!)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - setup
private extension StudyRecordTimeRecordViewController {
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        if isHistoryDidTapped {
            pickerView.selectRow(history!.year - years.first!, inComponent: 0, animated: true)
            pickerView.selectRow(history!.month - months.first!, inComponent: 1, animated: true)
            pickerView.selectRow(history!.day - days.first!, inComponent: 2, animated: true)
            pickerView.selectRow(history!.hour, inComponent: 3, animated: true)
            pickerView.selectRow(history!.minutes, inComponent: 4, animated: true)
        } else {
            let year = Int(Convert().stringFrom(Date(), format: "yyyy"))!
            let month = Int(Convert().stringFrom(Date(), format: "M"))!
            let day = Int(Convert().stringFrom(Date(), format: "d"))!
            pickerView.selectRow(year - years.first!, inComponent: 0, animated: true)
            pickerView.selectRow(month - months.first!, inComponent: 1, animated: true)
            pickerView.selectRow(day - days.first!, inComponent: 2, animated: true)
            pickerView.selectRow(0, inComponent: 3, animated: true)
            pickerView.selectRow(0, inComponent: 4, animated: true)
            history = History(year: year, month: month, day: day, hour: 0, minutes: 0)
        }
    }
    
}

// MARK: - UIPickerViewDelegate
extension StudyRecordTimeRecordViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch component {
            case 0: history?.year = row + years.first!
            case 1: history?.month = row + months.first!
            case 2: history?.day = row + days.first!
            case 3: history?.hour = row
            case 4: history?.minutes = row
            default: fatalError("予期しないcomponentがあります。")
        }
    }
    
}

// MARK: - UIPickerViewDataSource
extension StudyRecordTimeRecordViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0: return years.count
            case 1: return months.count
            case 2: return days.count
            case 3: return hours.count
            case 4: return minutes.count
            default: fatalError("予期しないcomponentがあります。")
        }
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
        switch component {
            case 0:
                label.text = "\(years[row])年"
                label.textAlignment = .right
            case 1:
                label.text = "\(months[row])月"
                label.textAlignment = .center
            case 2:
                label.text = "\(days[row])日"
                label.textAlignment = .left
            case 3:
                label.text = "\(hours[row])時間"
                label.textAlignment = .center
            case 4:
                label.text = "\(minutes[row])分"
                label.textAlignment = .left
            default: fatalError("予期しないcomponentがあります。")
        }
        return view
    }
    
}

// MARK: - HalfModalPresenterDelegate
extension StudyRecordTimeRecordViewController: HalfModalPresenterDelegate {
    
    var halfModalContentHeight: CGFloat {
        return contentView.frame.height
    }
    
}
