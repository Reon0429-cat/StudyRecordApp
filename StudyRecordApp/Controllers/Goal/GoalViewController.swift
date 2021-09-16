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
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    weak var delegate: GoalVCDelegate?
    private enum SegmentType: Int {
        case category
        case simple
    }
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var goals: [Goal] {
        return goalUseCase.goals
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSegmentedControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .goal)
        tableView.reloadData()
        
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        guard let segmentType = SegmentType(rawValue: sender.selectedSegmentIndex) else { return }
        switch segmentType {
            case .category:
                break
            case .simple:
                break
        }
    }
    
}

// MARK: - UITableViewDelegate
extension GoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return goals[indexPath.row].isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return goals[indexPath.row].isExpanded ? tableView.rowHeight : 200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension GoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        let goal = goals[indexPath.row]
        cell.configure(goal: goal)
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
}

// MARK: - GoalTableViewCellDelegate
extension GoalViewController: GoalTableViewCellDelegate {
    
    func memoButtonDidTapped(index: Int) {
        goalUseCase.toggleIsExpanded(at: index)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.tableView.cellForRow(
                at: IndexPath(row: index, section: 0)
            ) as? GoalTableViewCell
            let isExpanded = self.goals[index].isExpanded
            let isLastRow = (index == self.goals.count - 1)
            let isManyMemo = (cell?.frame.height ?? 0.0 > self.tableView.frame.height / 2)
            let isCellNil = (cell == nil)
            let shouldScrollToTop = isExpanded && (isManyMemo || isLastRow || isCellNil)
            if shouldScrollToTop {
                self.tableView.scrollToRow(at: IndexPath(row: index, section: 0),
                                           at: .top,
                                           animated: true)
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
    
    func setupSegmentedControl() {
        let index = 0
        segmentedControl.create([LocalizeKey.category.localizedString(),
                                 LocalizeKey.simple.localizedString()],
                                selectedIndex: index)
    }
    
}
