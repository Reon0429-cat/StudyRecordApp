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
// MARK: - ToDo カテゴリがないときはカテゴリ遷移ビューを非表示にする
// MARK: - ToDo カテゴリが見切れる
// MARK: - ToDo 統計機能
// MARK: - ToDo カテゴリや達成済みのものだけ並び替えられるようにする
// MARK: - ToDo rowでも達成済みかどうかのマークを切り替えられるようにする

final class GoalViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var statisticsButton: UIButton!
    @IBOutlet private weak var simpleButton: RadioButton!
    
    weak var delegate: GoalVCDelegate?
    private let selectedSegmentIndexKey = "selectedSegmentIndexKey"
    private let isSimpleModeKey = "simpleButtonIsFilledKey"
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private var categories: [Category] {
        goalUseCase.categories
    }
    private var isSimpleMode: Bool {
        UserDefaults.standard.bool(forKey: isSimpleModeKey)
    }
    
    enum ListType: CaseIterable {
        case category
        case achieved
        var title: String {
            switch self {
                case .category: return L10n.category
                case .achieved: return L10n.achieved
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMockCategory()
        setupSegmentedControl()
        setupSimpleButton()
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
            let category = Category(title: categoryTitle + " order\(index)",
                                    isExpanded: false,
                                    goals: goals,
                                    isAchieved: false,
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
    
    @IBAction func simpleButtonDidTapped(_ sender: Any) {
        simpleButton.setImage(isFilled: !isSimpleMode)
        UserDefaults.standard.set(!isSimpleMode, forKey: isSimpleModeKey)
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
        if goal.isExpanded {
            return tableView.rowHeight
        }
        // GoalSimpleTableViewCellのbaseViewの高さ(70) + padding(20)
        // GoalTableViewCellのbaseViewの高さ(180) + padding(20)
        return isSimpleMode ? 90 : 200
    }
    
    func getListType() -> ListType {
        let index = segmentedControl.selectedSegmentIndex
        let listType = ListType.allCases[index]
        return listType
    }
    
    func convert(section: Int) -> Int {
        let filterdCategories: [Category] = {
            if getListType() == .achieved {
                let achievedCategories = categories.filter { $0.isAchieved }
                return categories[0...achievedCategories[section].order].filter { !$0.isAchieved }
            }
            let unarchievedCategories = categories.filter { !$0.isAchieved }
            return categories[0...unarchievedCategories[section].order].filter { $0.isAchieved }
        }()
        return section + filterdCategories.count
    }
    
    func reconvert(convertedSection: Int) -> Int {
        let categories = categories[0...convertedSection]
        if getListType() == .achieved {
            let unAchievedCount = categories.filter { !$0.isAchieved }.count
            return convertedSection - unAchievedCount
        } else {
            let achievedCount = categories.filter { $0.isAchieved }.count
            return convertedSection - achievedCount
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if getListType() == .achieved {
            return categories.filter { $0.isAchieved }.count
        }
        return categories.filter { !$0.isAchieved }.count
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
        if isSimpleMode {
            let cell = tableView.dequeueReusableCustomCell(with: GoalSimpleTableViewCell.self)
            let category = categories[convert(section: indexPath.section)]
            let goal = category.goals[indexPath.row]
            cell.configure(goal: goal)
            cell.isHidden(!category.isExpanded)
            cell.changeMode(isEdit: delegate?.isEdit ?? false,
                            isEvenIndex: indexPath.row.isMultiple(of: 2))
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
            let category = categories[convert(section: indexPath.section)]
            let goal = category.goals[indexPath.row]
            cell.configure(goal: goal)
            cell.isHidden(!category.isExpanded)
            cell.changeMode(isEdit: delegate?.isEdit ?? false,
                            isEvenIndex: indexPath.row.isMultiple(of: 2))
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
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
        goalUseCase.toggleIsAchieved(at: convertedSection)
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
        let convertedIndexPath = IndexPath(row: indexPath.row,
                                           section: convert(section: indexPath.section))
        let alert = Alert.create(title: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.goalUseCase.deleteGoal(at: convertedIndexPath)
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
        let convertedIndexPath = IndexPath(row: indexPath.row,
                                           section: convert(section: indexPath.section))
        present(AddAndEditGoalViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.selectedIndexPath = convertedIndexPath
            vc.goalScreenType = .edit
        }
    }
    
    func baseViewLongPressDidRecognized() {
        delegate?.baseViewLongPressDidRecognized()
    }
    
}

// MARK: - setup
private extension GoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GoalHeaderView.self)
        tableView.registerCustomCell(GoalTableViewCell.self)
        tableView.registerCustomCell(GoalSimpleTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func setupSegmentedControl() {
        let titles = ListType.allCases.map { $0.title }
        let index = UserDefaults.standard.integer(forKey: selectedSegmentIndexKey)
        segmentedControl.create(titles, selectedIndex: index)
    }
    
    func setupSimpleButton() {
        simpleButton.setImage(isFilled: isSimpleMode)
        simpleButton.setTitle(L10n.simple)
        simpleButton.backgroundColor = .clear
    }
    
    func setupStatisticsButton() {
        statisticsButton.backgroundColor = .clear
    }
    
}
