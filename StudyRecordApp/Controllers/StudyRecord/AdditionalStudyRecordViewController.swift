//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class AdditionalStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
    }
    private let cellType = CellType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.registerCustomCell(StudyRecordMemoTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    static func instantiate() -> AdditionalStudyRecordViewController {
        let storyboard = UIStoryboard(name: "AdditionalStudyRecord", bundle: nil)
        let additionalStudyRecordVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! AdditionalStudyRecordViewController
        return additionalStudyRecordVC
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo 保存処理
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func backButtonDidTapped(_ sender: Any) {
        // MARK: - ToDo アラート
        dismiss(animated: true, completion: nil)
    }
    
}

extension AdditionalStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let alert = UIAlertController.withTextField(title: "タイトル", message: nil)
                present(alert, animated: true, completion: nil)
            case .graphColor:
                let studyRecordGraphColorVC = StudyRecordGraphColorViewController.instantiate()
                studyRecordGraphColorVC.modalPresentationStyle = .overCurrentContext
                present(studyRecordGraphColorVC, animated: true, completion: nil)
            case .memo:
                break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension AdditionalStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        let cell: UITableViewCell = {
            switch cellType {
                case .title:
                    return tableView.dequeueReusableCustomCell(with: StudyRecordTitleTableViewCell.self)
                case .graphColor:
                    return tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                case .memo:
                    return tableView.dequeueReusableCustomCell(with: StudyRecordMemoTableViewCell.self)
            }
        }()
        return cell
    }
    
}
