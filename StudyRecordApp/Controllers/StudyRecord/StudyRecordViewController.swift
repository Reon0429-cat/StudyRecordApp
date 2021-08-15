//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

// MARK: - ToDo グラフカラー選択時に該当の色を丸くする(追加と編集画面でそれぞれ確認する)
// MARK: - ToDo UINavigationControllerを削除したため、画面遷移の方法を変える
// MARK: - ToDo SwiftLintを導入する
// MARK: - ToDo SwiftGenを導入する
// MARK: - ToDo StudyRecord -> Recordにする

protocol StudyRecordVCDelegate: AnyObject {
    var isEdit: Bool { get }
    func viewWillAppear(records: [Record])
    func deleteButtonDidTappped(records: [Record])
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editButtonDidTapped),
                                               name: .editButtonDidTapped,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(records: records)
        tableView.reloadData()
        
    }
    
    @objc private func editButtonDidTapped() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate
extension StudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.TableView.headerHeight
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return records[indexPath.section].isExpanded ? tableView.rowHeight : 0
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return records[indexPath.section].isExpanded ? tableView.rowHeight : 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableCustomHeaderFooterView(with: StudyRecordSectionView.self)
        let record = records[section]
        sectionView.configure(record: record)
        let isEdit = delegate?.isEdit ?? false
        sectionView.changeMode(isEdit: isEdit)
        sectionView.tag = section
        sectionView.delegate = self
        return sectionView
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        view.tintColor = .clear
    }
    
}

// MARK: - UITableViewDataSource
extension StudyRecordViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTableViewCell.self)
        let record = records[indexPath.section]
        cell.configure(record: record)
        return cell
    }
    
}

// MARK: - StudyRecordSectionViewDelegate
extension StudyRecordViewController: StudyRecordSectionViewDelegate {
    
    func baseViewDidTapped(section: Int) {
        let editStudyRecordVC = EditStudyRecordViewController.instantiate()
        editStudyRecordVC.modalPresentationStyle = .fullScreen
        editStudyRecordVC.tappedSection = section
        present(editStudyRecordVC, animated: true, completion: nil)
    }
    
    func memoButtonDidTapped(section: Int) {
        recordUseCase.changeOpeningAndClosing(at: section)
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0,
                                            section: section)],
                             with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: 0,
                                            section: section),
                              at: .top,
                              animated: true)
    }
    
    func deleteButtonDidTappped(section: Int) {
        let alert = UIAlertController(title: "本当に削除しますか", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            self.recordUseCase.delete(at: section)
            self.tableView.reloadData()
            self.delegate?.deleteButtonDidTappped(records: self.records)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "閉じる", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func sortButtonDidTapped() {
        let studyRecordSortVC = StudyRecordSortViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: studyRecordSortVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - setup
private extension StudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTableViewCell.self)
        tableView.registerCustomCell(StudyRecordSectionView.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
}
