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

// MARK: - ToDo sectionの高さを変えられるようにする
// MARK: - ToDo 長押しで編集モードにする
// MARK: - ToDo タップでセクションタイトル編集
// MARK: - ToDo カテゴリがないときはカテゴリ遷移ビューを非表示にする
// MARK: - ToDo テーブルビューの上にセグメントを置いて達成済みとシンプルに切り替えられるようにする
// MARK: - ToDo カテゴリが見切れる
// MARK: - ToDo 統計機能
// MARK: - ToDo sectionのボタンを一つにまとめる

final class GoalViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var statisticsButton: UIButton!
    
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
        setupSegmentedControl()
        setupStatisticsButton()
        createMockCategory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .goal,
                                     isEnabledNavigationButton: !categories.isEmpty)
        
    }
    
    // MARK: - ToDo 消す
    func createMockCategory() {
        goalUseCase.deleteAllCategory()
        for _ in 0..<10 {
            let goalTitles = ["りんご", "バナナ", "ぶどう", "なし", "みかん"]
            var goals = [Category.Goal]()
            goalTitles.enumerated().forEach { index, title in
                let goal = Category.Goal(title: title,
                                         memo: "",
                                         isExpanded: false,
                                         priority: .init(mark: .heart,
                                                         number: .one),
                                         dueDate: Date(),
                                         createdDate: Date(),
                                         imageData: nil,
                                         order: index,
                                         identifier: UUID().uuidString)
                goals.append(goal)
            }
            let category = Category(title: ["ああああああああああああああああああああああああああ",
                                            "いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい",
                                           "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"]
                                        .randomElement() ?? "",
                                    isExpanded: false,
                                    goals: goals,
                                    order: 0,
                                    identifier: UUID().uuidString)
            goalUseCase.save(category: category)
        }
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
    @IBAction func segmentedControlValueDidChanged(_ sender: Any) {
        
    }
    
    @IBAction func statisticsButtonDidTapped(_ sender: Any) {
        
    }
    
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
        return GoalHeaderView.height
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: GoalHeaderView.self)
        let category = categories[section]
        headerView.configure(category: category)
        headerView.changeMode(isEdit: delegate?.isEdit ?? false)
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
            (0..<self.categories[section].goals.count).forEach {
                self.tableView.reloadRows(at: [IndexPath(row: $0, section: section)],
                                          with: .automatic)
            }
            self.tableView.reloadSections([section], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func sortButtonDidTapped(section: Int) {
        present(GoalSortViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.tappedSection = section
        }
    }
    
    func deleteButtonDidTapped(section: Int) {
        let alert = Alert.create(title: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.goalUseCase.deleteCategory(at: section)
                self.delegate?.deleteButtonDidTappped(isEmpty: self.categories.isEmpty)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
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
                self.goalUseCase.deleteGoal(at: indexPath)
                self.delegate?.deleteButtonDidTappped(isEmpty: self.categories.isEmpty)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func setupSegmentedControl() {
        let titles = [L10n.category, L10n.simple, L10n.achieved]
        segmentedControl.create(titles, selectedIndex: 0)
    }
    
    func setupStatisticsButton() {
        statisticsButton.backgroundColor = .clear
    }
    
}
