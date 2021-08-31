//
//  AdditionalGoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class AdditionalGoalViewController: UIViewController {
    
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var dismissButton: NavigationButton!
    @IBOutlet private weak var saveButton: NavigationButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum RowType: Int, CaseIterable {
        case title
        case category
        case memo
        case priority
        case image
        case dueDate
        case createdDate
        
        var title: String {
            switch self {
                case .title: return "タイトル"
                case .category: return "カテゴリー"
                case .memo: return "メモ"
                case .priority: return "優先度"
                case .image: return "画像"
                case .dueDate: return "期日"
                case .createdDate: return "作成日"
            }
        }
    }
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var halfModalPresenter = HalfModalPresenter()
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSaveButton()
        setupDismissButton()
        setupWaveView()
        
    }
    
}

// MARK: - func
private extension AdditionalGoalViewController {
    
    func showAlertWithTextField() {
        let alert = UIAlertController(title: "タイトル", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.inputtedTitle
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "閉じる", style: .destructive) { _ in
            self.inputtedTitle = self.oldInputtedTitle
        })
        alert.addAction(UIAlertAction(title: "追加", style: .default) { _ in
            self.oldInputtedTitle = self.inputtedTitle
            self.tableView.reloadData()
        })
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension AdditionalGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = RowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                showAlertWithTextField()
            case .category: break
            case .memo: break
            case .priority:
                let goalPriorityVC = GoalPriorityViewController.instantiate()
                halfModalPresenter.viewController = goalPriorityVC
                present(goalPriorityVC, animated: true, completion: nil)
            case .image: break
            case .dueDate: break
            case .createdDate: break
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension AdditionalGoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = RowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: false,
                               auxiliaryText: inputtedTitle)
                return cell
            case .category: return UITableViewCell()
            case .memo: return UITableViewCell()
            case .priority:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: true,
                               auxiliaryText: "")
                return cell
            case .image: return UITableViewCell()
            case .dueDate: return UITableViewCell()
            case .createdDate: return UITableViewCell()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalGoalViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
    }
    
}

extension AdditionalGoalViewController: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        if type == .save {
            // MARK: - 保存処理
            self.dismiss(animated: true, completion: nil)
        }
        if type == .dismiss {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - setup
private extension AdditionalGoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordCustomTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func setupSaveButton() {
        saveButton.delegate = self
        saveButton.type = .save
        saveButton.backgroundColor = .clear
    }
    
    func setupDismissButton() {
        dismissButton.delegate = self
        dismissButton.type = .dismiss
        dismissButton.backgroundColor = .clear
    }
    
    func setupWaveView() {
        topWaveView.create(isFill: true, marginY: 60)
    }
    
}
