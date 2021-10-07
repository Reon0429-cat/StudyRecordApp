//
//  GoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GoalVCDelegate: ScreenPresentationDelegate,
                         EditButtonSelectable {
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
        
        delegate?.screenDidPresented(screenType: .goal,
                                     isEnabledNavigationButton: !categories.isEmpty)
        tableView.reloadData()
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
}

// MARK: - func
private extension GoalViewController {
    
    func getRowHeight(at indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        guard category.isExpanded else { return 0 }
        let goal = category.goals[indexPath.row]
        return goal.isExpanded ? tableView.rowHeight : 200
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRowHeight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRowHeight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return GoalHeaderView.height + 35
        }
        return GoalHeaderView.height
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: GoalHeaderView.self)
        let category = categories[section]
        headerView.configure(category: category)
        headerView.delegate = self
        headerView.tag = section
        return headerView
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
        cell.isHidden(!category.isExpanded)
        cell.changeMode(isEdit: delegate?.isEdit ?? false,
                        isEvenIndex: indexPath.row.isMultiple(of: 2))
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        view.tintColor = .dynamicColor(light: .black, dark: .white)
    }
    
}

// MARK: - GoalHeaderViewDelegate
extension GoalViewController: GoalHeaderViewDelegate {
    
    func addButtonDidTapped(section: Int) {
        present(AddAndEditGoalViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            let row = self.categories[section].goals.count - 1
            vc.selectedIndexPath = IndexPath(row: row, section: section)
            vc.goalScreenType = .sectionAdd
        }
    }
    
    func foldingButtonDidTapped(section: Int) {
        goalUseCase.toggleCategoryIsExpanded(at: section)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            (0..<self.goalUseCase.categories[section].goals.count).forEach {
                self.tableView.reloadRows(at: [IndexPath(row: $0, section: section)],
                                          with: .automatic)
            }
            self.tableView.reloadSections([section], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
}

// MARK: - GoalTableViewCellDelegate
extension GoalViewController: GoalTableViewCellDelegate {
    
    func memoButtonDidTapped(indexPath: IndexPath) {
        goalUseCase.toggleGoalIsExpanded(at: indexPath)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func deleteButtonDidTapped(indexPath: IndexPath) {
        let alert = Alert.create(title: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.goalUseCase.deleteGaol(at: indexPath)
                self.delegate?.deleteButtonDidTappped(isEmpty: self.categories.isEmpty)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.goalUseCase.categories.forEach { category in
                    category.goals.forEach { goal in
                        print("DEBUG_PRINT: ",
                              "title: ", goal.title,
                              "order", goal.order)
                    }
                    print("DEBUG_PRINT: =====================")
                }
                
                
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
    func goalViewDidTapped(indexPath: IndexPath) {
        present(AddAndEditGoalViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.selectedIndexPath = indexPath
            vc.goalScreenType = .edit
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}
