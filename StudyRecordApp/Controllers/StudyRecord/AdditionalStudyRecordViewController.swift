//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class AdditionalStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
    }
    private let cellType = CellType.allCases
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var selectedGraphColor: UIColor = .white
    private var inputtedMemo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        saveButton.isEnabled = false
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.registerCustomCell(StudyRecordMemoTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "保存せずに閉じますか", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "保存する", style: .default) { _ in
            self.saveRecord()
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func controlSaveButton() {
        if !inputtedTitle.isEmpty && selectedGraphColor != .white {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func saveRecord() {
        let record = Record(title: inputtedTitle,
                            time: Time(today: 0, total: 0),
                            isExpanded: false,
                            graphColor: GraphColor(redValue: selectedGraphColor.redValue,
                                                   greenValue: selectedGraphColor.greenValue,
                                                   blueValue: selectedGraphColor.blueValue,
                                                   alphaValue: selectedGraphColor.alphaValue),
                            memo: inputtedMemo,
                            order: recordUseCase.records.count)
        recordUseCase.save(record: record)
    }
    
    static func instantiate() -> AdditionalStudyRecordViewController {
        let storyboard = UIStoryboard(name: "AdditionalStudyRecord", bundle: nil)
        let additionalStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! AdditionalStudyRecordViewController
        return additionalStudyRecordVC
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        saveRecord()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        if !inputtedTitle.isEmpty && selectedGraphColor != .white {
            showAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension AdditionalStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let alert = UIAlertController(title: "タイトル", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.text = self.inputtedTitle
                    textField.delegate = self
                }
                alert.addAction(UIAlertAction(title: "閉じる", style: .default) { _ in
                    self.inputtedTitle = self.oldInputtedTitle
                })
                alert.addAction(UIAlertAction(title: "追加する", style: .default) { _ in
                    self.oldInputtedTitle = self.inputtedTitle
                    self.tableView.reloadData()
                })
                present(alert, animated: true, completion: nil)
            case .graphColor:
                let studyRecordGraphColorVC = StudyRecordGraphColorViewController.instantiate()
                studyRecordGraphColorVC.delegate = self
                present(studyRecordGraphColorVC, animated: true, completion: nil)
            case .memo:
                let studyRecordMemoVC = StudyRecordMemoViewController.instantiate()
                studyRecordMemoVC.inputtedMemo = inputtedMemo
                studyRecordMemoVC.delegate = self
                present(studyRecordMemoVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension AdditionalStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTitleTableViewCell.self)
                cell.configure(title: inputtedTitle)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: selectedGraphColor)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordMemoTableViewCell.self)
                cell.configure(memo: inputtedMemo)
                return cell
        }
    }
    
}

extension AdditionalStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedGraphColor = color
        tableView.reloadData()
        controlSaveButton()
    }
    
}

extension AdditionalStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        tableView.reloadData()
    }
    
}

extension AdditionalStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        controlSaveButton()
    }
    
}
