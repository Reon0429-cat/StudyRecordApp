//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addRecordButton: UIButton!
    @IBOutlet private weak var editRecordButton: UIBarButtonItem!
    
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var records: [Record] {
        recordUseCase.records
    }
    private enum TableState {
        case normal
        case editing
    }
    private var tableState: TableState = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableState = .normal
        editRecordButton.title = "編集"
        if records.count == 0 {
            editRecordButton.isEnabled = false
        } else {
            editRecordButton.isEnabled = true
        }
        tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addRecordButton.layer.cornerRadius = addRecordButton.frame.height / 2
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTableViewCell.self)
        tableView.registerCustomCell(StudyRecordSectionView.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction private func addRecordButtonDidTapped(_ sender: Any) {
        let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: additionalStudyRecordVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func editButtonDidTapped(_ sender: Any) {
        switch tableState {
            case .normal:
                editRecordButton.title = "完了"
                tableState = .editing
            case .editing:
                editRecordButton.title = "編集"
                tableState = .normal
        }
        tableView.reloadData()
    }
    
}

extension StudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 120
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
        let isEditing = tableState == .editing
        sectionView.changeMode(isEditing: isEditing)
        sectionView.tag = section
        sectionView.delegate = self
        return sectionView
    }
    
}

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
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        view.tintColor = .white
    }
    
}

extension StudyRecordViewController: StudyRecordSectionViewDelegate {
    
    func baseViewDidTapped(section: Int) {
        let editStudyRecordVC = EditStudyRecordViewController.instantiate()
        let record = records[section]
        editStudyRecordVC.tappedSection = section
        editStudyRecordVC.inputtedTitle = record.title
        editStudyRecordVC.oldInputtedTitle = record.title
        editStudyRecordVC.selectedGraphColor = UIColor(record: record)
        editStudyRecordVC.inputtedMemo = record.memo
        self.navigationController?.pushViewController(editStudyRecordVC, animated: true)
    }
    
    func memoButtonDidTapped(section: Int) {
        recordUseCase.changeOpeningAndClosing(at: section)
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)],
                             with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteButtonDidTappped(section: Int) {
        let alert = UIAlertController(title: "本当に削除しますか", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
            self.recordUseCase.delete(at: section)
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            if self.records.count == 0 {
                self.tableState = .normal
                self.editRecordButton.title = "編集"
                self.editRecordButton.isEnabled = false
            } else {
                self.editRecordButton.isEnabled = true
            }
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

private extension UIColor {
    
    convenience init(record: Record) {
        self.init(red: record.graphColor.redValue,
                  green: record.graphColor.greenValue,
                  blue: record.graphColor.blueValue,
                  alpha: record.graphColor.alphaValue)
    }
    
}
