//
//  GoalSortViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/08.
//

import UIKit

final class GoalSortViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomWaveView: WaveView!
    
    var tappedSection: Int?
    private let goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        goalUseCase.categories
    }
    private var goals: [Category.Goal] {
        if let tappedSection = tappedSection {
            return categories[tappedSection].goals
        }
        return []
    }
    private var isCategorySort: Bool {
        tappedSection == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSubCustomNavigationBar()
        setupWaveViews()
        
    }
    
}

// MARK: - func
private extension GoalSortViewController {
    
    func controlBottomWaveView(indexPath: IndexPath) {
        if indexPath.row == getRowCount(index: indexPath.row) - 1 {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let tableBottomMaxY = tableView.rectForRow(at: indexPath).maxY
            let shouldHideWave = bottomWaveView.frame.minY - bottomWaveView.frame.height < tableBottomMaxY
            tableView.isScrollEnabled = shouldHideWave
            bottomWaveView.isHidden = shouldHideWave
        }
    }
    
    func getRowTitle(index: Int) -> String {
        if isCategorySort {
            return categories[index].title
        }
        return goals[index].title
    }
    
    func getRowCount(index: Int) -> Int {
        if isCategorySort {
            return categories.count
        }
        return goals.count
    }
    
}

// MARK: - SortableViewControllerProtocol
extension GoalSortViewController: SortableViewControllerProtocol { }

// MARK: - UITableViewDelegate
extension GoalSortViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _tableView(tableView, heightForRowAt: indexPath)
    }
    
}

// MARK: - UITableViewDataSource
extension GoalSortViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        _tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return getRowCount(index: section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordSortTableViewCell.self)
        controlBottomWaveView(indexPath: indexPath)
        let isAchieved: Bool = {
            if isCategorySort {
                return categories[indexPath.row].isAchieved
            }
            return goals[indexPath.row].isChecked
        }()
        cell.configure(title: getRowTitle(index: indexPath.row), isAchieved: isAchieved)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        if isCategorySort {
            goalUseCase.sortCategory(from: sourceIndexPath,
                                     to: destinationIndexPath)
        } else {
            guard let section = tappedSection else { return }
            goalUseCase.sortGoal(tappedSection: section,
                                 from: sourceIndexPath.row,
                                 to: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return _tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return _tableView(tableView, viewForHeaderInSection: section)
    }
    
}

// MARK: - UITableViewDragDelegate
extension GoalSortViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        return _tableView(tableView,
                          itemsForBeginning: session,
                          at: indexPath,
                          title: getRowTitle(index: indexPath.row))
    }
    
}

// MARK: - UITableViewDropDelegate
extension GoalSortViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView,
                   dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return _tableView(tableView,
                          dropSessionDidUpdate: session,
                          withDestinationIndexPath: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   performDropWith coordinator: UITableViewDropCoordinator) {
        return
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension GoalSortViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        dismiss(animated: true)
    }
    
    var navTitle: String {
        return L10n.largeSort
    }
    
}

// MARK: - setup
private extension GoalSortViewController {
    
    func setupTableView() {
        _setup(tableView: tableView, vc: self)
        tableView.registerCustomCell(StudyRecordSortTableViewCell.self)
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
    func setupWaveViews() {
        bottomWaveView.create(isFill: false, marginY: 30, isShuffled: true)
    }
    
}
