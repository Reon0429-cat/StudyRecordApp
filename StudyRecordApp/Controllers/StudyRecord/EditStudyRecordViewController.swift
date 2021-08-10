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

// MARK: - ToDo グラフカラーのセルをタップした時に想定外のタイルが丸くなってしまうバグを修正する
// MARK: - タイトルまたはグラフカラーが未入力状態になった時は保存できないようにする

final class EditStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
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
        let cellType = CellType(rawValue: indexPath.row)!
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
                break
            case .history:
                break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension EditStudyRecordViewController: UITableViewDataSource {
    
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
                cell.configure(title: selectedRecord.title)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: UIColor(record: selectedRecord))
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordMemoTableViewCell.self)
                cell.configure(memo: selectedRecord.memo)
                return cell
            case .timeRecord:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTimeRecordTableViewCell.self)
                return cell
            case .history:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordHistoryTableViewCell.self)
                return cell
        }
    }
    
}

extension EditStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedRecord.graphColor = GraphColor(color: color)
        tableView.reloadData()
    }
    
}

extension EditStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        selectedRecord.memo = memo
        tableView.reloadData()
    }
    
}

extension EditStudyRecordViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        selectedRecord.title = textField.text ?? ""
    }

}

