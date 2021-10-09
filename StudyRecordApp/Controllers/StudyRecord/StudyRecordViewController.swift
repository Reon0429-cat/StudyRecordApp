//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

// MARK: - ToDo リアルタイムで同期して更新する処理も実装する(realm)
// MARK: - ToDo グラフカラー選択時に該当の色を丸くする(追加と編集画面でそれぞれ確認する)
// MARK: - ToDo sectionの高さを変えられるようにする

protocol EditButtonSelectable {
    var isEdit: Bool { get }
    func deleteButtonDidTappped(isEmpty: Bool)
    func baseViewLongPressDidRecognized()
}

protocol StudyRecordVCDelegate: ScreenPresentationDelegate,
                                EditButtonSelectable {
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
        
        delegate?.screenDidPresented(screenType: .record,
                                     isEnabledNavigationButton: !records.isEmpty)
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
        return 20
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
        let studyTime = recordUseCase.getStudyTime(at: indexPath.row)
        let isEdit = delegate?.isEdit ?? false
        cell.configure(record: record,
                       studyTime: studyTime)
        cell.changeMode(isEdit: isEdit,
                        isEvenIndex: indexPath.row.isMultiple(of: 2))
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
}

// MARK: - RecordTableViewCellDelegate
extension StudyRecordViewController: RecordTableViewCellDelegate {
    
    func baseViewTapDidRecognized(row: Int) {
        present(EditStudyRecordViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.selectedRow = row
        }
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
        let alert = Alert.create(title: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.recordUseCase.delete(record: self.records[row])
                self.tableView.reloadData()
                self.delegate?.deleteButtonDidTappped(isEmpty: self.records.isEmpty)
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
