//
//  AlarmViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/09.
//

import UIKit

final class AlarmViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let alarms = Alarm.data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableViewCell.nib,
                           forCellReuseIdentifier: AlarmTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        
    }
    
}

extension AlarmViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension AlarmViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier) as! AlarmTableViewCell
        let alarm = alarms[indexPath.row]
        cell.configure(alarm: alarm)
        return cell
    }
    
}
