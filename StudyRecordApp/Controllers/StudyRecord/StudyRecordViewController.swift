//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

private enum EditButtonState {
    case edit
    case completion
    var title: String {
        switch self {
            case .edit: return "編集"
            case .completion: return "完了"
        }
    }
    mutating func toggle() {
        switch self {
            case .edit: self = .completion
            case .completion: self = .edit
        }
    }
}

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
    private var editButtonState: EditButtonState = .edit {
        didSet {
            editRecordButton.title = editButtonState.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editButtonState = .edit
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
    
    @IBAction private func addRecordButtonDidTapped(_ sender: Any) {
        let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: additionalStudyRecordVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction private func editButtonDidTapped(_ sender: Any) {
        editButtonState.toggle()
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
        let isEditing = editButtonState == .completion
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
        editStudyRecordVC.selectedRecord = Record(record: record) 
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
                self.editButtonState = .edit
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

// MARK: - setup
private extension StudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTableViewCell.self)
        tableView.registerCustomCell(StudyRecordSectionView.self)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
}
