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
    private let selectedSegmentIndexKey = "selectedSegmentIndexKey"
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        goalUseCase.categories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createMockCategory()
        setupSegmentedControl()
        setupTableView()
        setupStatisticsButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(screenType: .goal,
                                     isEnabledNavigationButton: !categories.isEmpty)
        
    }
    
    // MARK: - ToDo 消す
    func createMockCategory() {
        goalUseCase.deleteAllCategory()
        ["AAA", "BBB", "CCC", "DDD"].enumerated().forEach { index, categoryTitle in
            let goalTitles = ["000", "111", "222"]
            var goals = [Category.Goal]()
            goalTitles.enumerated().forEach { index, title in
                let goal = Category.Goal(title: categoryTitle + title,
                                         memo: title + title + title,
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
            let listType: ListType = {
                if categoryTitle != "AAA" {
                    return .category
                }
                return .achieved
            }()
            let category = Category(title: categoryTitle + " order\(index)",
                                    isExpanded: false,
                                    goals: goals,
                                    listType: listType,
                                    order: index,
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
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex,
                                  forKey: selectedSegmentIndexKey)
        tableView.reloadData()
    }
    
    @IBAction func statisticsButtonDidTapped(_ sender: Any) {
        
    }
    
}

// MARK: - func
private extension GoalViewController {
    
    func getRowHeight(at indexPath: IndexPath) -> CGFloat {
        let category = categories[convert(section: indexPath.section)]
        guard category.isExpanded else { return 0 }
        let goal = category.goals[indexPath.row]
        return goal.isExpanded ? tableView.rowHeight : 200
    }
    
    func getListType() -> ListType {
        let index = segmentedControl.selectedSegmentIndex
        let listType = ListType(rawValue: index) ?? .category
        return listType
    }
    
    func convert(section: Int) -> Int {
        let filterdCategories: [Category] = {
            if getListType() == .achieved {
                let achievedCategories = categories.filter { $0.listType == .achieved }
                return categories[0...achievedCategories[section].order].filter { $0.listType != .achieved }
            }
            let unarchievedCategories = categories.filter { $0.listType != .achieved }
            return categories[0...unarchievedCategories[section].order].filter { $0.listType == .achieved }
        }()
        return section + filterdCategories.count
    }
    
    func reconvert(convertedSection: Int) -> Int {
        let categories = goalUseCase.categories[0...convertedSection]
        if getListType() == .achieved {
            let unAchievedCount = categories.filter { $0.listType == .category }.count
            return convertedSection - unAchievedCount
        } else {
            let achievedCount = categories.filter { $0.listType == .achieved }.count
            return convertedSection - achievedCount
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if getListType() == .achieved {
            return goalUseCase.categories.filter { $0.listType == .achieved }.count
        }
        return goalUseCase.categories.filter { $0.listType == .category }.count
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
        headerView.tag = convert(section: section)
        let category = categories[convert(section: section)]
        headerView.configure(category: category)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let category = categories[convert(section: section)]
        return category.goals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        let category = categories[convert(section: indexPath.section)]
        let goal = category.goals[indexPath.row]
        cell.configure(goal: goal)
        cell.isHidden(!category.isExpanded)
        cell.changeMode(isEdit: delegate?.isEdit ?? false,
                        isEvenIndex: indexPath.row.isMultiple(of: 2))
        cell.indexPath = IndexPath(row: indexPath.row,
                                   section: convert(section: indexPath.section))
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
    
    func settingButtonDidTapped(convertedSection: Int) {
        let achieveButtonTitle = getListType() == .achieved ? L10n.unarchive : L10n.achieve
        let alert = Alert.create(preferredStyle: .alert)
            .addAction(title: L10n.add) { self.addButtonDidTapped(convertedSection: convertedSection) }
            .addAction(title: L10n.edit) { self.editButtonDidTapped(convertedSection: convertedSection) }
            .addAction(title: L10n.delete) { self.deleteButtonDidTapped(convertedSection: convertedSection) }
            .addAction(title: L10n.sort) { self.sortButtonDidTapped(convertedSection: convertedSection) }
            .addAction(title: achieveButtonTitle) { self.achieveButtonDidTapped(convertedSection: convertedSection) }
            .addAction(title: L10n.close, style: .destructive)
        present(alert, animated: true)
    }
    
    func foldingButtonDidTapped(convertedSection: Int) {
        goalUseCase.toggleCategoryIsExpanded(at: convertedSection)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            let section = self.reconvert(convertedSection: convertedSection)
            (0..<self.categories[convertedSection].goals.count).forEach {
                self.tableView.reloadRows(at: [IndexPath(row: $0, section: section)],
                                          with: .automatic)
            }
            self.tableView.reloadSections([section], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    private func achieveButtonDidTapped(convertedSection: Int) {
        if getListType() == .achieved {
            goalUseCase.changeListType(to: .category, at: convertedSection)
        } else {
            goalUseCase.changeListType(to: .achieved, at: convertedSection)
        }
        tableView.reloadData()
    }
    
    private func addButtonDidTapped(convertedSection: Int) {
        present(AddAndEditGoalViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            let row = self.categories[convertedSection].goals.count - 1
            vc.selectedIndexPath = IndexPath(row: row, section: convertedSection)
            vc.goalScreenType = .sectionAdd
        }
    }
    
    private func editButtonDidTapped(convertedSection: Int) {
    }
    
    private func sortButtonDidTapped(convertedSection: Int) {
        present(GoalSortViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.tappedSection = convertedSection
        }
    }
    
    private func deleteButtonDidTapped(convertedSection: Int) {
        let alert = Alert.create(title: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.goalUseCase.deleteCategory(at: convertedSection)
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
        let convertedIndexPath = IndexPath(row: indexPath.row,
                                           section: convert(section: indexPath.section))
        goalUseCase.toggleGoalIsExpanded(at: convertedIndexPath)
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath],
                                      with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func deleteButtonDidTapped(indexPath: IndexPath) {
        let indexPath = IndexPath(row: indexPath.row,
                                  section: convert(section: indexPath.section))
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
        let indexPath = IndexPath(row: indexPath.row,
                                  section: convert(section: indexPath.section))
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
        let index = UserDefaults.standard.integer(forKey: selectedSegmentIndexKey)
        segmentedControl.create(titles, selectedIndex: index)
    }
    
    func setupStatisticsButton() {
        statisticsButton.backgroundColor = .clear
    }
    
}
