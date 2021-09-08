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
    private var halfModalPresenter = HalfModalPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedRecord = recordUseCase.records[selectedRow]
        setupTableView()
        setupSaveButton()
        setupDismissButton()
        setupWaveViews()
        
    }
    
}

// MARK: - func
private extension EditStudyRecordViewController {
    
    func showAlertWithTextField() {
        oldInputtedTitle = selectedRecord.title
        let alert = Alert.create(title: "タイトル")
            .setTextField { textField in
                textField.text = self.selectedRecord.title
                textField.delegate = self
            }
            .addAction(title: "閉じる", style: .destructive) {
                self.selectedRecord.title = self.oldInputtedTitle
            }
            .addAction(title: "編集する") {
                self.oldInputtedTitle = self.selectedRecord.title
                self.saveButton.isEnabled(!self.oldInputtedTitle.isEmpty)
                self.tableView.reloadData()
            }
        present(alert, animated: true)
    }
    
    func showAlert() {
        let alert = Alert.create(title: "編集内容を破棄しますか")
            .addAction(title: "破棄する", style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: "閉じる", style: .default)
        present(alert, animated: true)
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
                    vc.inputtedMemo = self.selectedRecord.memo
                    vc.delegate = self
                }
            case .timeRecord:
                present(StudyRecordTimeRecordViewController.self) { vc in
                    vc.isHistoryDidTapped = false
                    self.halfModalPresenter.viewController = vc
                    vc.delegate = self
                }
            case .history:
                present(StudyRecordTimeRecordViewController.self) { vc in
                    let index = self.getHistoryCount(row: indexPath.row)
                    if let history = self.selectedRecord.histories?[index] {
                        vc.history = history
                    }
                    vc.tappedHistoryIndex = index
                    vc.isHistoryDidTapped = true
                    self.halfModalPresenter.viewController = vc
                    vc.delegate = self
                }
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
        let isEnabled = (rowCount > 7)
        tableView.isScrollEnabled = isEnabled
        bottomWaveView.isHidden = isEnabled
        
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
                guard var histories = selectedRecord.histories else { fatalError("history is nil") }
                histories = recordUseCase.sorted(histories: histories, at: selectedRow)
                selectedRecord.histories = histories
                cell.configure(history: histories[index])
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
    
    func saveButtonDidTapped(history: History, isHistory: Bool) {
        if isHistory {
            selectedRecord.histories?.append(history)
        } else {
            let isSameDateExisted = isSameDateValidation(history: history)
            let isHistoriesIsEmpty = selectedRecord.histories?.isEmpty ?? true
            if !isSameDateExisted || isHistoriesIsEmpty {
                selectedRecord.histories?.append(history)
            }
        }
        tableView.reloadData()
    }
    
    private func isSameDateValidation(history: History) -> Bool {
        guard let histories = selectedRecord.histories else { return false }
        for (index, _history) in histories.enumerated() {
            if _history.year == history.year
                && _history.month == history.month
                && _history.day == history.day {
                var hour = histories[index].hour + history.hour
                var minutes = histories[index].minutes + history.minutes
                if minutes >= 60 {
                    hour += 1
                    minutes -= 60
                }
                if hour >= 24 {
                    let alert = Alert.create(title: "\(history.year)年\(history.month)月\(history.day)日の記録時間が24時間以上になってしまいます。")
                        .addAction(title: "閉じる")
                    dismiss(animated: true) {
                        self.present(alert, animated: true)
                    }
                } else {
                    let history = History(year: history.year,
                                          month: history.month,
                                          day: history.day,
                                          hour: hour,
                                          minutes: minutes)
                    selectedRecord.histories?[index] = history
                }
                return true
            }
        }
        return false
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
            dismiss(animated: true)
        }
        if type == .dismiss {
            if selectedRecord == recordUseCase.records[selectedRow] {
                dismiss(animated: true)
            } else {
                showAlert()
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
