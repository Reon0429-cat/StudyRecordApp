//
//  EditStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

private enum CellType: Int, CaseIterable {
    case title
    case graphColor
    case memo
    case timeRecord
    case history
}

final class EditStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var cellType = CellType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.registerCustomCell(StudyRecordMemoTableViewCell.self)
        tableView.registerCustomCell(StudyRecordTimeRecordTableViewCell.self)
        tableView.registerCustomCell(StudyRecordHistoryTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    static func instantiate() -> EditStudyRecordViewController {
        let storyboard = UIStoryboard(name: "EditStudyRecord", bundle: nil)
        let editStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! EditStudyRecordViewController
        return editStudyRecordVC
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 保存処理
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension EditStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTitleTableViewCell.self)
                cell.configure(title: "", mandatoryLabelIsHidden: true)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: .white, mandatoryLabelIsHidden: true)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordMemoTableViewCell.self)
                cell.configure(memo: "")
                return cell
            case .timeRecord:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordTimeRecordTableViewCell.self)
                return cell
            case .history:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordHistoryTableViewCell.self)
                return cell
        }
    }
    
}
