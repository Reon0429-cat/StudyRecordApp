//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

// MARK: - ToDo cellがふるえる

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addRecordButton: UIButton!
    
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        tableView.estimatedRowHeight = 100
    }
    
    @IBAction private func addRecordButtonDidTapped(_ sender: Any) {
        let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
        let nav = UINavigationController(rootViewController: additionalStudyRecordVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
}

extension StudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return recordUseCase.records[indexPath.section].isExpanded ? tableView.rowHeight : 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let studyRecordSectionView = tableView.dequeueReusableCustomHeaderFooterView(with: StudyRecordSectionView.self)
        let record = recordUseCase.records[section]
        studyRecordSectionView.configure(record: record) { [weak self] in
            guard let self = self else { return }
            self.recordUseCase.changeOpeningAndClosing(at: section)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: section)],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
        studyRecordSectionView.delegate = self
        return studyRecordSectionView
    }
    
}

extension StudyRecordViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recordUseCase.records.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTableViewCell.self)
        let record = recordUseCase.records[indexPath.section]
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
    
    func baseViewDidTapped() {
        let editStudyRecordVC = EditStudyRecordViewController.instantiate()
        self.navigationController?.pushViewController(editStudyRecordVC, animated: true)
    }
    
}
