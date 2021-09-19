//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - ToDo リアルタイムで同期して更新する処理も実装する(realm)
// MARK: - ToDo グラフカラー選択時に該当の色を丸くする(追加と編集画面でそれぞれ確認する)
// MARK: - ToDo SwiftGenを導入する

protocol StudyRecordVCDelegate: ScreenPresentationDelegate {
    var isEdit: Bool { get }
    func deleteButtonDidTappped(records: [Record])
    func baseViewLongPressDidRecognized()
}

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: StudyRecordVCDelegate?
    private var records: [Record] {
        viewModel.outputs.records
    }
    private let viewModel: StudyRecordViewModelType = StudyRecordViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.viewWillAppear()
        
    }
    
    private func setupBindings() {
        viewModel.outputs.event
            .drive { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .notifyDisplayed:
                        self.delegate?.screenDidPresented(screenType: .record,
                                                          isEnabledNavigationButton: !self.records.isEmpty)
                    case .reloadData:
                        self.tableView.reloadData()
                    case .presentEditStudyRecordVC(let row):
                        self.presentEditStudyRecordVC(row: row)
                    case .notifyLongPress:
                        self.delegate?.baseViewLongPressDidRecognized()
                    case .reloadRows(let row):
                        self.reloadRows(row: row)
                    case .scrollToRow(let row):
                        self.scrollToRow(row: row)
                    case .presentAlert(let row):
                        self.presentAlert(row: row)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

// MARK: - func
private extension StudyRecordViewController {
    
    func presentEditStudyRecordVC(row: Int) {
        present(EditStudyRecordViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.selectedRow = row
        }
    }
    
    func reloadRows(row: Int) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func scrollToRow(row: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.viewModel.inputs.scrollToRow(tableView: self.tableView, row: row)
        }
    }
    
    func presentAlert(row: Int) {
        let alert = Alert.create(title: LocalizeKey.doYouReallyWantToDeleteThis.localizedString())
            .addAction(title: LocalizeKey.delete.localizedString(), style: .destructive) {
                self.viewModel.inputs.deleteRecord(row: row)
                self.tableView.reloadData()
                self.delegate?.deleteButtonDidTappped(records: self.records)
                self.dismiss(animated: true)
            }
            .addAction(title: LocalizeKey.close.localizedString()) {
                self.dismiss(animated: true)
            }
        self.present(alert, animated: true)
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
        let studyTime = viewModel.outputs.getStudyTime(at: indexPath.row)
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
        viewModel.inputs.baseViewTapDidRecognized(row: row)
    }
    
    func baseViewLongPressDidRecognized() {
        viewModel.inputs.baseViewLongPressDidRecognized()
    }
    
    func memoButtonDidTapped(row: Int) {
        viewModel.inputs.memoButtonDidTapped(row: row)
    }
    
    func deleteButtonDidTappped(row: Int) {
        viewModel.inputs.deleteButtonDidTappped(row: row)
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
