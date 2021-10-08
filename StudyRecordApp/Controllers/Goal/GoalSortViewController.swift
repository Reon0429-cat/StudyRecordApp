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
    
    private let goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        goalUseCase.categories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSubCustomNavigationBar()
        setupWaveViews()
        
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
        categories.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == categories.count - 1 {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let tableBottomMaxY = tableView.rectForRow(at: indexPath).maxY
            let shouldHideWave = bottomWaveView.frame.minY - bottomWaveView.frame.height < tableBottomMaxY
            tableView.isScrollEnabled = shouldHideWave
            bottomWaveView.isHidden = shouldHideWave
        }
        
        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordSortTableViewCell.self)
        let category = categories[indexPath.row]
        cell.configure(title: category.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        goalUseCase.sortCategory(from: sourceIndexPath,
                                 to: destinationIndexPath)
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
        let categoryTitle = categories[indexPath.row].title
        return _tableView(tableView,
                          itemsForBeginning: session,
                          at: indexPath,
                          title: categoryTitle)
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
