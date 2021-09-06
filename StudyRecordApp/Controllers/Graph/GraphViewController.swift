//
//  GraphViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GraphVCDelegate: AnyObject {
    func viewWillAppear(index: Int)
}

final class GraphViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: GraphVCDelegate?
    private var recordUseCase = RecordUseCase(
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
        
        delegate?.viewWillAppear(index: self.view.tag)
        tableView.reloadData()
        
    }
    
}

// MARK: - UITableViewDelegate
extension GraphViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}

// MARK: - UITableViewDataSource
extension GraphViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return recordUseCase.records.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GraphTableViewCell.self)
        let record = recordUseCase.read(at: indexPath.row)
        let newRecord = Record(title: record.title,
                               histories: record.histories?.reversed(),
                               isExpanded: record.isExpanded,
                               graphColor: record.graphColor,
                               memo: record.memo,
                               yearID: record.yearID,
                               order: record.order)
        DispatchQueue.main.async {
            cell.configure(record: newRecord)
        }
        cell.onSegmentedControlEvent = {
            self.tableView.reloadRows(at: [IndexPath(row: indexPath.row,
                                                     section: indexPath.section)],
                                      with: .automatic)
        }
        return cell
    }
    
}

// MARK: - setup
private extension GraphViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GraphTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
}


