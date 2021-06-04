//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StudyRecordTableViewCell.nib,
                           forCellReuseIdentifier: StudyRecordTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        
    }
    
    
}

extension StudyRecordViewController: UITableViewDelegate {
    
}

extension StudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudyRecordTableViewCell.identifier,
                                                 for: indexPath) as! StudyRecordTableViewCell
        return cell
    }
    
    
}
