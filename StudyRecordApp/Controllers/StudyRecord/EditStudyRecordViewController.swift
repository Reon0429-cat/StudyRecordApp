//
//  EditStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class EditStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var saveButton: NavigationButton!
    @IBOutlet private weak var dismissButton: NavigationButton!
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
        case timeRecord
        case history
    }
    private func getCellType(row: Int) -> CellType {
        if isHistoryType(row: row) {
            return .history
        }
        return CellType(rawValue: row) ?? .title
    }
    private func getHistoryCount(row: Int) -> Int {
        return row - (CellType.allCases.count - 1)
    }
    private func isHistoryType(row: Int) -> Bool {
        return getHistoryCount(row: row) >= 0
    }
    private var recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var rowCount: Int {
        (CellType.allCases.count - 1) + (selectedRecord.histories?.count ?? 0)
    }
    var selectedRow: Int!
    private var selectedRecord: Record!
    private var oldInputtedTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedRecord = recordUseCase.records[selectedRow]
        setupTableView()
        setupSaveButton()
        setupDismissButton()
        setupWaveViews()
        
    }
    
    static func instantiate() -> EditStudyRecordViewController {
        let storyboard = UIStoryboard(name: "EditStudyRecord", bundle: nil)
        let editStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! EditStudyRecordViewController
        return editStudyRecordVC
    }
    
}

// MARK: - UITableViewDelegate
extension EditStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = getCellType(row: indexPath.row)
        switch cellType {
            case .title:
                let alert = UIAlertController(title: "タイトル",
                                              message: nil,
                                              preferredStyle: .alert)
                oldInputtedTitle = selectedRecord.title
                alert.addTextField { textField in
                    textField.text = self.selectedRecord.title
                    textField.delegate = self
                }
                alert.addAction(UIAlertAction(title: "閉じる", style: .destructive) { _ in
                    self.selectedRecord.title = self.oldInputtedTitle
                })
                alert.addAction(UIAlertAction(title: "編集する", style: .default) { _ in
                    self.oldInputtedTitle = self.selectedRecord.title
                    self.saveButton.isEnabled(!self.oldInputtedTitle.isEmpty)
                    self.tableView.reloadData()
                })
                present(alert, animated: true, completion: nil)
            case .graphColor:
                let studyRecordGraphColorVC = StudyRecordGraphColorViewController.instantiate()
                studyRecordGraphColorVC.delegate = self
                present(studyRecordGraphColorVC, animated: true, completion: nil)
            case .memo:
                let studyRecordMemoVC = StudyRecordMemoViewController.instantiate()
                studyRecordMemoVC.inputtedMemo = selectedRecord.memo
                studyRecordMemoVC.delegate = self
                present(studyRecordMemoVC, animated: true, completion: nil)
            case .timeRecord:
                let studyRecordTimeRecordVC = StudyRecordTimeRecordViewController.instantiate()
                studyRecordTimeRecordVC.delegate = self
                studyRecordTimeRecordVC.isHistory = false
                present(studyRecordTimeRecordVC, animated: true, completion: nil)
            case .history:
                let studyRecordTimeRecordVC = StudyRecordTimeRecordViewController.instantiate()
                let index = getHistoryCount(row: indexPath.row)
                if let history = selectedRecord.histories?[index] {
                    studyRecordTimeRecordVC.history = history
                }
                studyRecordTimeRecordVC.isHistory = true
                studyRecordTimeRecordVC.tappedHistoryIndex = index
                studyRecordTimeRecordVC.delegate = self
                present(studyRecordTimeRecordVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isHistoryType(row: indexPath.row) ? 50 : 80
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
extension EditStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == rowCount - 1 {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let tableBottomMaxY = tableView.rectForRow(at: indexPath).maxY
            let shouldHideWave = bottomWaveView.frame.minY - bottomWaveView.frame.height < tableBottomMaxY
            tableView.isScrollEnabled = shouldHideWave
            bottomWaveView.isHidden = shouldHideWave
        }
        
        let cellType = getCellType(row: indexPath.row)
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: "タイトル",
                               mandatoryIsHidden: false,
                               auxiliaryText: selectedRecord.title)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                let color = UIColor(record: selectedRecord)
                cell.configure(color: color)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: "メモ",
                               mandatoryIsHidden: true,
                               auxiliaryText: selectedRecord.memo)
                return cell
            case .timeRecord:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: "時間を記録する",
                               mandatoryIsHidden: true,
                               auxiliaryText: "")
                return cell
            case .history:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordHistoryTableViewCell.self)
                let index = getHistoryCount(row: indexPath.row)
                if let history = selectedRecord.histories?[index] {
                    cell.configure(history: history)
                }
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = getHistoryCount(row: indexPath.row)
            selectedRecord.histories?.remove(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return isHistoryType(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
}

// MARK: - StudyRecordGraphColorVCDelegate
extension EditStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedRecord.graphColor = GraphColor(color: color)
        saveButton.isEnabled(color != .white)
        tableView.reloadData()
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension EditStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        selectedRecord.memo = memo
        tableView.reloadData()
    }
    
}

// MARK: - StudyRecordTimeRecordVCDelegate
extension EditStudyRecordViewController: StudyRecordTimeRecordVCDelegate {
    
    func saveButtonDidTapped(history: History) {
        selectedRecord.histories?.append(history)
        tableView.reloadData()
    }
    
    func deleteButtonDidTapped(index: Int) {
        selectedRecord.histories?.remove(at: index)
        tableView.reloadData()
    }
    
    func editButtonDidTapped(index: Int, history: History) {
        selectedRecord.histories?[index] = history
        tableView.reloadData()
    }
    
}

// MARK: - UITextFieldDelegate
extension EditStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedRecord.title = textField.text ?? ""
    }
    
}

// MARK: - NavigationButtonDelegate
extension EditStudyRecordViewController: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        if type == .save {
            recordUseCase.update(record: selectedRecord, at: selectedRow)
            dismiss(animated: true, completion: nil)
        }
        if type == .dismiss {
            if selectedRecord == recordUseCase.records[selectedRow] {
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "編集内容を破棄しますか", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "破棄する", style: .destructive) { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - setup
extension EditStudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordCustomTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.registerCustomCell(StudyRecordHistoryTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func setupSaveButton() {
        saveButton.delegate = self
        saveButton.type = .save
        saveButton.backgroundColor = .clear
    }
    
    func setupDismissButton() {
        dismissButton.delegate = self
        dismissButton.type = .dismiss
        dismissButton.backgroundColor = .clear
    }
    
    func setupWaveViews() {
        topWaveView.create(isFill: true, marginY: 60)
        bottomWaveView.create(isFill: false, marginY: 30, isShuffled: true)
    }
    
}
