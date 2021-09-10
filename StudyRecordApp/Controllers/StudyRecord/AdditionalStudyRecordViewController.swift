//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class AdditionalStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: NavigationButton!
    @IBOutlet private weak var dismissButton: NavigationButton!
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
    }
    private let cellTypes = CellType.allCases
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var selectedGraphColor: UIColor = .white
    private var inputtedMemo = ""
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty && selectedGraphColor != .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSaveButton()
        setupDismissButton()
        setupWaveView()
        
    }
    
}

// MARK: - func
private extension AdditionalStudyRecordViewController {
    
    func controlSaveButton() {
        saveButton.isEnabled(isMandatoryItemFilled)
    }
    
    func saveRecord() {
        let record = Record(title: inputtedTitle,
                            histories: nil,
                            isExpanded: false,
                            graphColor: GraphColor(color: selectedGraphColor),
                            memo: inputtedMemo,
                            yearID: UUID().uuidString,
                            monthID: UUID().uuidString,
                            order: recordUseCase.records.count)
        recordUseCase.save(record: record)
    }
    
    func showAlert() {
        let alert = Alert.create(title: "保存せずに閉じますか")
            .addAction(title: "閉じる", style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: "保存する") {
                self.saveRecord()
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
    func showAlertWithTextField() {
        let alert = Alert.create(title: "タイトル")
            .setTextField { textField in
                textField.text = self.inputtedTitle
                textField.delegate = self
            }
            .addAction(title: "閉じる", style: .destructive) {
                self.inputtedTitle = self.oldInputtedTitle
            }
            .addAction(title: "追加") {
                self.oldInputtedTitle = self.inputtedTitle
                self.tableView.reloadData()
            }
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension AdditionalStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                showAlertWithTextField()
            case .graphColor:
                present(StudyRecordGraphColorViewController.self,
                        modalPresentationStyle: .overCurrentContext,
                        modalTransitionStyle: .crossDissolve) { vc in
                    vc.delegate = self
                }
            case .memo:
                present(StudyRecordMemoViewController.self,
                        modalPresentationStyle: .overCurrentContext,
                        modalTransitionStyle: .crossDissolve) { vc in
                    vc.inputtedMemo = self.inputtedMemo
                    vc.delegate = self
                }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension AdditionalStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: "タイトル", mandatoryIsHidden: false, auxiliaryText: inputtedTitle)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: selectedGraphColor)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: "メモ", mandatoryIsHidden: true, auxiliaryText: inputtedMemo)
                return cell
        }
    }
    
}

// MARK: - StudyRecordGraphColorVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedGraphColor = color
        tableView.reloadData()
        controlSaveButton()
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        tableView.reloadData()
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        controlSaveButton()
    }
    
}

// MARK: - NavigationButtonDelegate
extension AdditionalStudyRecordViewController: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        if type == .save {
            saveRecord()
            dismiss(animated: true)
        }
        if type == .dismiss {
            if isMandatoryItemFilled {
                showAlert()
            } else {
                dismiss(animated: true)
            }
        }
    }
    
}

// MARK: - setup
private extension AdditionalStudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func setupSaveButton() {
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        saveButton.isEnabled(false)
        saveButton.type = .save
        saveButton.delegate = self
        saveButton.backgroundColor = .clear
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupDismissButton() {
        dismissButton.delegate = self
        dismissButton.type = .dismiss
        dismissButton.backgroundColor = .clear
    }
    
    func setupWaveView() {
        topWaveView.create(isFill: true, marginY: 60)
        bottomWaveView.create(isFill: false, marginY: 30, isShuffled: true)
    }
    
}

