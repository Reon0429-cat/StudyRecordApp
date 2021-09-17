//
//  GoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GoalVCDelegate: ScreenPresentationDelegate {
    
}

final class GoalViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: GoalVCDelegate?
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        return goalUseCase.categories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .goal)
        tableView.reloadData()
        
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        let goal = category.goals[indexPath.row]
        return goal.isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        let goal = category.goals[indexPath.row]
        return goal.isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return GoalHeaderView.height + 30
        }
        return GoalHeaderView.height
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: GoalHeaderView.self)
        let category = categories[section]
        headerView.configure(category: category)
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        view.tintColor = .dynamicColor(light: .black, dark: .white)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
        return category.goals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        let category = categories[indexPath.section]
        let goal = category.goals[indexPath.row]
        cell.configure(goal: goal)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
}

// MARK: - GoalTableViewCellDelegate
extension GoalViewController: GoalTableViewCellDelegate {
    
    func memoButtonDidTapped(indexPath: IndexPath) {
        goalUseCase.toggleIsExpanded(at: indexPath)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.tableView.cellForRow(at: indexPath) as? GoalTableViewCell
            let goals = self.categories[indexPath.section].goals
            let isExpanded = goals[indexPath.row].isExpanded
            let isLastRow = (indexPath.row == goals.count - 1)
            let isManyMemo = (cell?.frame.height ?? 0.0 > self.tableView.frame.height / 2)
            let isCellNil = (cell == nil)
            let shouldScrollToTop = isExpanded && (isManyMemo || isLastRow || isCellNil)
            if shouldScrollToTop {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
}

// MARK: - setup
private extension GoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GoalTableViewCell.self)
        tableView.registerCustomCell(GoalHeaderView.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
}
