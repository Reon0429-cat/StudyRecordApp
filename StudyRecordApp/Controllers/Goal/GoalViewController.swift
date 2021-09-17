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
    private var goals = [[Goal]]()
    private var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let categoryTitles = goalUseCase.goals
            .map { $0.category.title }
        sectionTitles = NSOrderedSet(array: categoryTitles).array as! [String]
        if sectionTitles.contains("") {
            let index = sectionTitles.firstIndex(of: "") ?? 0
            sectionTitles.remove(at: index)
            sectionTitles.append("未分類")
        }
        goals.removeAll()
        sectionTitles.forEach { _ in
            goals.append([])
        }
        goalUseCase.goals.forEach { goal in
            for i in 0..<sectionTitles.count {
                if goal.category.title == sectionTitles[i] {
                    goals[i].append(goal)
                }
            }
        }
        
        
        delegate?.screenDidPresented(screenType: .goal)
        tableView.reloadData()
        
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
}

// MARK: - UITableViewDelegate
extension GoalViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return goals[indexPath.section][indexPath.row].isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return goals[indexPath.section][indexPath.row].isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension GoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return goals[section].count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        let goal = goals[indexPath.section][indexPath.row]
        cell.configure(goal: goal)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
}

// MARK: - GoalTableViewCellDelegate
extension GoalViewController: GoalTableViewCellDelegate {
    
    func memoButtonDidTapped(indexPath: IndexPath) {
        let goals = goalUseCase.goals
            .filter { $0.category.title == sectionTitles[indexPath.section] }
        let goal = goals[indexPath.row]
        let index = goalUseCase.goals.firstIndex { $0 == goal } ?? 0
        goalUseCase.toggleIsExpanded(at: index)
        self.goals[indexPath.section][indexPath.row].isExpanded.toggle()
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.tableView.cellForRow(at: indexPath) as? GoalTableViewCell
            let isExpanded = self.goals[indexPath.section][indexPath.row].isExpanded
            let isLastRow = (indexPath.row == self.goals.count - 1)
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
}
