//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class StudyRecordViewController: MyTabBarController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var records = Record.data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StudyRecordTableViewCell.nib,
                           forCellReuseIdentifier: StudyRecordTableViewCell.identifier)
        tableView.register(StudyRecordSectionView.nib,
                           forHeaderFooterViewReuseIdentifier: StudyRecordSectionView.identifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
}

extension StudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return records[indexPath.section].expanded ? tableView.rowHeight : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let studyRecordSectionView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: StudyRecordSectionView.identifier
        ) as! StudyRecordSectionView
        let record = records[section]
        studyRecordSectionView.configure(record: record) { [weak self] in
            guard let self = self else { return }
            self.records[section].expanded.toggle()
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
        return records.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudyRecordTableViewCell.identifier,
                                                 for: indexPath) as! StudyRecordTableViewCell
        let record = records[indexPath.section]
        cell.configure(record: record)
        cell.didChangedText = { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
    }
    
}

extension StudyRecordViewController: StudyRecordSectionViewDelegate { } 
