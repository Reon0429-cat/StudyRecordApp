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
        
        goalUseCase.deleteAllCategory()
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
        ["A", "BBB", "CCCC", "DD"].enumerated().forEach { index, categoryTitle in
            let goalTitles = ["000000", "111111", "222222"]
            var goals = [Category.Goal]()
            goalTitles.enumerated().forEach { index, title in
                let a = categoryTitle + title + categoryTitle + title + categoryTitle + title
                let prioritys: [Category.Goal.Priority] = [.init(mark: .star, number: .one),
                                                           .init(mark: .star, number: .two),
                                                           .init(mark: .star, number: .three),
                                                           .init(mark: .star, number: .four),
                                                           .init(mark: .star, number: .five),
                                                           .init(mark: .heart, number: .one),
                                                           .init(mark: .heart, number: .two),
                                                           .init(mark: .heart, number: .three),
                                                           .init(mark: .heart, number: .four),
                                                           .init(mark: .heart, number: .five)]
                let goal = Category.Goal(title: a + a + a,
                                         memo: title + title + title,
                                         isExpanded: false,
                                         priority: prioritys.randomElement()!,
                                         isChecked: Bool.random(),
                                         dueDate: Date(),
                                         createdDate: Date(),
                                         imageData: nil,
                                         order: index,
                                         identifier: UUID().uuidString)
                goals.append(goal)
            }
            var title = ""
            for _ in 0..<20 {
                title += categoryTitle
            }
            let category = Category(title: title,
                                    isExpanded: false,
                                    goals: goals,
                                    isAchieved: false,
                                    order: index,
                                    identifier: UUID().uuidString)
            goalUseCase.save(category: category)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
    @IBAction func segmentedControlValueDidChanged(_ sender: Any) {
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex,
                                  forKey: selectedSegmentIndexKey)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func simpleButtonDidTapped(_ sender: Any) {
        simpleButton.setImage(isFilled: !isSimpleMode)
        UserDefaults.standard.set(!isSimpleMode, forKey: isSimpleModeKey)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func statisticsButtonDidTapped(_ sender: Any) {
        present(GoalStatisticsViewController.self)
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
        return categories.filter {
            getListType() == .achieved ? $0.isAchieved : !$0.isAchieved
        }.count
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
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return GoalHeaderView.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        let filteredCategories = categories.filter {
            return getListType() == .achieved ? $0.isAchieved : !$0.isAchieved
        }
        if section == filteredCategories.count - 1 {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCustomHeaderFooterView(with: GoalHeaderView.self)
        headerView.tag = convert(section: section)
        let category = categories[convert(section: section)]
        let isAchieved = getListType() == .achieved
        headerView.configure(category: category, isAchieved: isAchieved)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let category = categories[convert(section: section)]
        return category.goals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalTableViewCellProtocol = {
            if isSimpleMode {
                return tableView.dequeueReusableCustomCell(with: GoalSimpleTableViewCell.self)
            }
            return tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        }()
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
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        view.tintColor = .dynamicColor(light: .white,
                                       dark: .black)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayFooterView view: UIView,
                   forSection section: Int) {
        view.tintColor = .dynamicColor(light: .white,
                                       dark: .black)
    }
    
}

// MARK: - GoalHeaderViewDelegate
extension GoalViewController: GoalHeaderViewDelegate {
    
    func foldingButtonDidTapped(convertedSection: Int) {
        goalUseCase.toggleCategoryIsExpanded(at: convertedSection)
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.reloadData()
            }
        }
    }
    
    func achieveButtonDidTapped(convertedSection: Int) {
        goalUseCase.toggleIsAchieved(at: convertedSection)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addButtonDidTapped(convertedSection: Int) {
        present(AddAndEditGoalViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            let row = self.categories[convertedSection].goals.count - 1
            vc.selectedIndexPath = IndexPath(row: row, section: convertedSection)
            vc.goalScreenType = .sectionAdd
        }
    }
    
    func editButtonDidTapped(convertedSection: Int) {
        let category = categories[convertedSection]
        var _textField = UITextField()
        let alert = Alert.create(title: L10n.largeTitle, preferredStyle: .alert)
            .setTextField { textField in
                textField.tintColor = .dynamicColor(light: .black, dark: .white)
                let isUncategorized = (category.title == L10n.uncategorized)
                textField.text = isUncategorized ? "" : category.title
                _textField = textField
            }
            .addAction(title: L10n.close, style: .destructive)
            .addAction(title: L10n.edit, style: .default) {
                guard let text = _textField.text else { return }
                let categoryTitle = text.isEmpty ? L10n.uncategorized : text
                let newCategory = Category(category: category, title: categoryTitle)
                self.goalUseCase.update(category: newCategory)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        present(alert, animated: true)
    }
    
    func sortButtonDidTapped(convertedSection: Int) {
        present(GoalSortViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.tappedSection = convertedSection
        }
    }
    
    func deleteButtonDidTapped(convertedSection: Int) {
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
            self.tableView.performBatchUpdates {
                self.tableView.reloadRows(at: [indexPath],
                                          with: .automatic)
            }
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
    
    func achievementButtonDidTapped(indexPath: IndexPath) {
        let convertedIndexPath = IndexPath(row: indexPath.row,
                                           section: convert(section: indexPath.section))
        goalUseCase.toggleGoalIsChecked(at: convertedIndexPath)
        DispatchQueue.main.async {
            let section = self.reconvert(convertedSection: convertedIndexPath.section)
            let indexPath = IndexPath(row: convertedIndexPath.row,
                                      section: section)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
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
