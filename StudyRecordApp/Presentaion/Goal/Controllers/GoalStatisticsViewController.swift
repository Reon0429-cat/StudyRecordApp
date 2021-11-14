//
//  GoalStatisticsViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/16.
//

import UIKit

final class GoalStatisticsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var settingUnachievedCategoryButton: RadioButton!
    @IBOutlet private weak var separatorView: UIView!

    private let settingUnachievedCategoryKey = "SettingUnachievedCategoryKey"
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        goalUseCase.categories
    }

    private var shouldOnlyUnachievedCategory: Bool {
        UserDefaults.standard.bool(forKey: settingUnachievedCategoryKey)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSettingUnachievedCategoryButton()
        setupSeparatorView()

    }

}

// MARK: - IBAction func
private extension GoalStatisticsViewController {

    @IBAction func settingUnachievedCategoryButtonDidTapped(_ sender: Any) {
        settingUnachievedCategoryButton.setImage(isFilled: !shouldOnlyUnachievedCategory)
        UserDefaults.standard.set(!shouldOnlyUnachievedCategory,
                                  forKey: settingUnachievedCategoryKey)
        tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate
extension GoalStatisticsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }

}

// MARK: - UITableViewDataSource
extension GoalStatisticsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // 全体を表示するので、+1
        if shouldOnlyUnachievedCategory {
            return categories.filter { !$0.isAchieved }.count + 1
        }
        return categories.count + 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalStatisticsTableViewCell.self)
        let categories: [Category] = {
            if shouldOnlyUnachievedCategory {
                return self.categories.filter { !$0.isAchieved }
            }
            return self.categories
        }()
        let category: Category = {
            let isOverall = indexPath.row == 0
            if isOverall {
                let goals = categories.map { $0.goals }.flatMap { $0 }
                return Category(title: L10n.overall,
                                isExpanded: false,
                                goals: goals,
                                isAchieved: false,
                                order: Int.max,
                                identifier: UUID().uuidString)
            }
            // 帳尻を合わせるために-1
            return categories[indexPath.row - 1]
        }()
        cell.configure(category: category)
        return cell
    }

}

// MARK: - setup
private extension GoalStatisticsViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GoalStatisticsTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
    }

    func setupSettingUnachievedCategoryButton() {
        settingUnachievedCategoryButton.setTitle(L10n.showOnlyCategoryUnachieved)
        let isFill = shouldOnlyUnachievedCategory
        settingUnachievedCategoryButton.setImage(isFilled: isFill)
    }

    func setupSeparatorView() {
        separatorView.backgroundColor = .separatorColor
    }

}
