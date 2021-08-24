//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

// MARK: - ToDo リアルタイムで同期して更新する処理も実装する(realm)
// MARK: - ToDo グラフカラー選択時に該当の色を丸くする(追加と編集画面でそれぞれ確認する)
// MARK: - ToDo UINavigationControllerを削除したため、画面遷移の方法を変える
// MARK: - ToDo SwiftLintを導入する
// MARK: - ToDo SwiftGenを導入する

protocol StudyRecordVCDelegate: AnyObject {
    var isEdit: Bool { get }
    func viewWillAppear(records: [Record], index: Int)
    func deleteButtonDidTappped(records: [Record])
    func baseViewLongPressDidRecognized()
}

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var records: [Record] {
        recordUseCase.records
    }
    weak var delegate: StudyRecordVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(records: records, index: self.view.tag)
        tableView.reloadData()
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate
extension StudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return records[indexPath.row].isExpanded ? tableView.rowHeight : 120
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return records[indexPath.row].isExpanded ? tableView.rowHeight : 120
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
extension StudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: RecordTableViewCell.self)
        let record = records[indexPath.row]
        let isEdit = delegate?.isEdit ?? false
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure(record: record)
        cell.changeMode(isEdit: isEdit,
                        isEvenIndex: indexPath.row.isMultiple(of: 2))
        return cell
    }
    
}

// MARK: - RecordTableViewCellDelegate
extension StudyRecordViewController: RecordTableViewCellDelegate {
    
    func baseViewTapDidRecognized(row: Int) {
        let editStudyRecordVC = EditStudyRecordViewController.instantiate()
        editStudyRecordVC.selectedRow = row
        editStudyRecordVC.modalPresentationStyle = .fullScreen
        present(editStudyRecordVC, animated: true, completion: nil)
    }
    
    func baseViewLongPressDidRecognized() {
        delegate?.baseViewLongPressDidRecognized()
    }
    
    func memoButtonDidTapped(row: Int) {
        recordUseCase.changeOpeningAndClosing(at: row)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.tableView.cellForRow(
                at: IndexPath(row: row, section: 0)
            ) as? RecordTableViewCell
            let isExpanded = self.records[row].isExpanded
            let isLastRow = (row == self.records.count - 1)
            let isManyMemo = (cell?.frame.height ?? 0.0 > self.tableView.frame.height / 2)
            let isCellNil = (cell == nil)
            let shouldScrollToTop = isExpanded && (isManyMemo || isLastRow || isCellNil)
            if shouldScrollToTop {
                self.tableView.scrollToRow(at: IndexPath(row: row, section: 0),
                                           at: .top,
                                           animated: true)
            }
        }
    }
    
    func deleteButtonDidTappped(row: Int) {
        let alert = UIAlertController(title: "本当に削除しますか", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            self.recordUseCase.delete(at: row)
            self.tableView.reloadData()
            self.delegate?.deleteButtonDidTappped(records: self.records)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "閉じる", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - setup
private extension StudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(RecordTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
}
