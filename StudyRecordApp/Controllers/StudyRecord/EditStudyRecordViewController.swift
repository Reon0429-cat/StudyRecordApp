//
//  EditStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

private enum CellType: Int, CaseIterable {
    case title
    case graphColor
    case memo
    case timeRecord
    case history
}

final class EditStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    
    private var cellType = CellType.allCases
    private var recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    var tappedSection: Int!
    var selectedRecord: Record!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.registerCustomCell(StudyRecordMemoTableViewCell.self)
        tableView.registerCustomCell(StudyRecordTimeRecordTableViewCell.self)
        tableView.registerCustomCell(StudyRecordHistoryTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    static func instantiate() -> EditStudyRecordViewController {
        let storyboard = UIStoryboard(name: "EditStudyRecord", bundle: nil)
        let editStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! EditStudyRecordViewController
        return editStudyRecordVC
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        recordUseCase.update(record: selectedRecord, at: tappedSection)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CellType(rawValue: indexPath.row)
        switch cellType {
            case .title:
                let alert = UIAlertController(title: "タイトル",
                                              message: nil,
                                              preferredStyle: .alert)
                var oldInputtedTitle = selectedRecord.title
                alert.addTextField { textField in
                    textField.text = self.selectedRecord.title
                    textField.delegate = self
                }
                alert.addAction(UIAlertAction(title: "閉じる", style: .default) { _ in
                    self.selectedRecord.title = oldInputtedTitle
                })
                alert.addAction(UIAlertAction(title: "編集する", style: .default) { _ in
                    oldInputtedTitle = self.selectedRecord.title
                    if oldInputtedTitle.isEmpty {
                        self.saveButton.isEnabled = false
                    } else {
                        self.saveButton.isEnabled = true
                    }
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
                present(studyRecordTimeRecordVC, animated: true, completion: nil)
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row < cellType.count - 1) ? 80 : 50
    }
    
}

extension EditStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return (cellType.count - 1) + (selectedRecord.histories?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTitleTableViewCell.self)
                cell.configure(title: selectedRecord.title)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                let color = UIColor(record: selectedRecord)
                cell.configure(color: color)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordMemoTableViewCell.self)
                cell.configure(memo: selectedRecord.memo)
                return cell
            case .timeRecord:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTimeRecordTableViewCell.self)
                return cell
            default:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordHistoryTableViewCell.self)
                if let history = selectedRecord.histories?[indexPath.row - (self.cellType.count - 1)] {
                    cell.configure(date: history.date,
                                   hour: history.hour,
                                   minutes: history.minutes) 
                }
                return cell
        }
    }
    
}

extension EditStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedRecord.graphColor = GraphColor(color: color)
        if color == .white {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
        tableView.reloadData()
    }
    
}

extension EditStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        selectedRecord.memo = memo
        tableView.reloadData()
    }
    
}

extension EditStudyRecordViewController: StudyRecordTimeRecordVCDelegate {
    
    func saveButtonDidTapped(hour: Int, minutes: Int, date: String) {
        selectedRecord.histories?.append(History(date: date,
                                                 hour: hour,
                                                 minutes: minutes))
        tableView.reloadData()
    }
    
}

extension EditStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedRecord.title = textField.text ?? ""
    }
    
}

