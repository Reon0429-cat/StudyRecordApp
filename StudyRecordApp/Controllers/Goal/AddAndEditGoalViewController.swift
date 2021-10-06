//
//  AddAndEditGoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

enum GoalScreenType {
    case add
    case sectionAdd
    case categoryAdd
    case edit
}

enum AddAndEditGoalRowType: Int, CaseIterable {
    case title
    case category
    case memo
    case priority
    case dueDate
    case createdDate
    case photo
    
    var title: String {
        switch self {
            case .title:
                return L10n.largeTitle
            case .category:
                return L10n.largeCategory
            case .memo:
                return L10n.largeMemo
            case .priority:
                return L10n.largePriority
            case .dueDate:
                return L10n.dueDate
            case .createdDate:
                return L10n.createdDate
            case .photo:
                return L10n.photo
        }
    }
}

final class AddAndEditGoalViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var goalScreenType: GoalScreenType?
    var selectedIndexPath: IndexPath?
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var inputtedCategoryTitle = ""
    private var oldInputtedCategoryTitle = ""
    private var inputtedMemo = ""
    private var inputtedImageData: Data?
    private var inputtedPriority = Category.Goal.Priority(mark: .star, number: .one)
    private var inputtedDate = (created: Date(), due: Date())
    private var halfModalPresenter = HalfModalPresenter()
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty
    }
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    private func getDateType(type: AddAndEditGoalRowType) -> GoalDateType {
        switch type {
            case .createdDate: return .created
            case .dueDate: return .due
            default: fatalError("typeが不適")
        }
    }
    private func getDate(type: AddAndEditGoalRowType) -> Date {
        switch type {
            case .createdDate: return inputtedDate.created
            case .dueDate: return inputtedDate.due
            default: fatalError("typeが不適")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputItems()
        setupTableView()
        setupSubCustomNavigationBar()
        
    }
    
}

// MARK: - func
private extension AddAndEditGoalViewController {
    
    func showAlertWithTextField(rowType: AddAndEditGoalRowType) {
        if rowType == .title {
            let alert = Alert.create(title: L10n.largeTitle)
                .setTextField { textField in
                    textField.text = self.inputtedTitle
                    textField.tag = rowType.rawValue
                    textField.delegate = self
                }
                .addAction(title: L10n.close,
                           style: .destructive) {
                    self.inputtedTitle = self.oldInputtedTitle
                }
                .addAction(title: L10n.add) {
                    self.oldInputtedTitle = self.inputtedTitle
                    self.tableView.reloadData()
                }
            present(alert, animated: true)
        }
        if rowType == .category {
            let alert = Alert.create(title: L10n.largeCategory)
                .setTextField { textField in
                    textField.text = self.inputtedCategoryTitle
                    textField.tag = rowType.rawValue
                    textField.delegate = self
                    let keyboardView = CategoryKeyboardView(frame: CGRect(x: 0,
                                                                          y: 0,
                                                                          width: self.view.frame.width,
                                                                          height: 45))
                    keyboardView.delegate = self
                    textField.inputAccessoryView = keyboardView
                }
                .addAction(title: L10n.close,
                           style: .destructive) {
                    self.inputtedCategoryTitle = self.oldInputtedCategoryTitle
                }
                .addAction(title: L10n.add) {
                    self.oldInputtedCategoryTitle = self.inputtedCategoryTitle
                    self.tableView.reloadData()
                }
            present(alert, animated: true)
        }
    }
    
    func showAlert() {
        let alert = Alert.create(title: L10n.doYouWantToCloseWithoutSaving)
            .addAction(title: L10n.close, style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.save) {
                self.saveGoal()
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
    func saveGoal() {
        let categoryTitle: String = {
            if inputtedCategoryTitle.isEmpty {
                return L10n.uncategorized
            }
            return inputtedCategoryTitle
        }()
        let goal = Category.Goal(title: inputtedTitle,
                                 memo: inputtedMemo,
                                 isExpanded: false,
                                 priority: inputtedPriority,
                                 dueDate: inputtedDate.due,
                                 createdDate: inputtedDate.created,
                                 imageData: inputtedImageData)
        guard let goalScreenType = goalScreenType else { return }
        switch goalScreenType {
            case .add:
                let category = Category(title: categoryTitle,
                                        isExpanded: true,
                                        goals: [goal],
                                        identifier: UUID().uuidString)
                goalUseCase.save(category: category)
            case .sectionAdd, .categoryAdd:
                guard let indexPath = selectedIndexPath else { return }
                goalUseCase.save(goal: goal, section: indexPath.section)
            case .edit:
                guard let indexPath = selectedIndexPath else { return }
                goalUseCase.update(goal: goal, at: indexPath)
        }
    }
    
    func presentTo(_ sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.modalPresentationStyle = .fullScreen
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
    }
    
    func presentStudyRecordMemoVC() {
        present(StudyRecordMemoViewController.self,
                modalPresentationStyle: .overCurrentContext,
                modalTransitionStyle: .crossDissolve) { vc in
            vc.inputtedMemo = self.inputtedMemo
            vc.delegate = self
        }
    }
    
    func presentGoalPriorityVC() {
        present(GoalPriorityViewController.self) { vc in
            vc.delegate = self
            vc.inputtedPriority = self.inputtedPriority
            self.halfModalPresenter.viewController = vc
        }
    }
    
    func presentGoalTimeVC(rowType: AddAndEditGoalRowType) {
        present(GoalTimeViewController.self) { vc in
            vc.delegate = self
            vc.dateType = self.getDateType(type: rowType)
            vc.inputtedDate = self.getDate(type: rowType)
            self.halfModalPresenter.viewController = vc
        }
    }
    
    func presentPhotoActionSheet(row: Int) {
        var alert = Alert.create(preferredStyle: .actionSheet)
            .addAction(title: L10n.takeAPhoto) {
                self.presentTo(.camera)
            }
            .addAction(title: L10n.selectFromLibrary) {
                self.presentTo(.photoLibrary)
            }
        if inputtedImageData != nil {
            alert = alert.addAction(title: L10n.deletePhoto,
                                    style: .destructive) {
                self.inputtedImageData = nil
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: row,
                                                             section: 0)],
                                              with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
        alert = alert.addAction(title: L10n.close,
                                style: .cancel)
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension AddAndEditGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = AddAndEditGoalRowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                showAlertWithTextField(rowType: rowType)
            case .category:
                guard let goalScreenType = goalScreenType else { return }
                if goalScreenType == .add {
                    showAlertWithTextField(rowType: rowType)
                }
            case .memo:
                presentStudyRecordMemoVC()
            case .priority:
                presentGoalPriorityVC()
            case .dueDate, .createdDate:
                presentGoalTimeVC(rowType: rowType)
            case .photo:
                presentPhotoActionSheet(row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if AddAndEditGoalRowType(rawValue: indexPath.row) == .photo && inputtedImageData != nil {
            return tableView.rowHeight
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
}

// MARK: - UITableViewDataSource
extension AddAndEditGoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return AddAndEditGoalRowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = AddAndEditGoalRowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                return configureTitleCell(rowType: rowType)
            case .category:
                return configureCategoryCell(rowType: rowType)
            case .memo:
                return configureMemoCell(rowType: rowType)
            case .priority:
                return configurePriorityCell(rowType: rowType)
            case .createdDate, .dueDate:
                return configureDateCell(rowType: rowType)
            case .photo:
                return configurePhotoCell(rowType: rowType)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension AddAndEditGoalViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let rowType = AddAndEditGoalRowType(rawValue: textField.tag)
        if rowType == .title {
            inputtedTitle = textField.text ?? ""
        }
        if rowType == .category {
            inputtedCategoryTitle = textField.text ?? ""
        }
        subCustomNavigationBar.saveButton(isEnabled: isMandatoryItemFilled)
    }
    
}

// MARK: - GoalPriorityVCDelegate
extension AddAndEditGoalViewController: GoalPriorityVCDelegate {
    
    func addButtonDidTapped(priority: Category.Goal.Priority) {
        inputtedPriority = priority
        tableView.reloadData()
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension AddAndEditGoalViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        tableView.reloadData()
    }
    
}

// MARK: - GoalTimeVCDelegate
extension AddAndEditGoalViewController: GoalTimeVCDelegate {
    
    func saveButtonDidTapped(date: Date, dateType: GoalDateType) {
        switch dateType {
            case .created:
                inputtedDate.created = date
            case .due:
                inputtedDate.due = date
        }
        tableView.reloadData()
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension AddAndEditGoalViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() {
        saveGoal()
        dismiss(animated: true)
    }
    
    func dismissButtonDidTapped() {
        if isMandatoryItemFilled {
            showAlert()
        } else {
            dismiss(animated: true)
        }
    }
    
    var navTitle: String {
        if let goalScreenType = goalScreenType {
            if goalScreenType == .edit {
                return L10n.largeEdit
            }
        }
        return L10n.largeAdd
    }
    
}

// MARK: - AdditionalCategoryVCDelegate
extension AddAndEditGoalViewController: AdditionalCategoryVCDelegate {
    
    func saveButtonDidTapped(at index: Int?) {
        if let index = index {
            let category = goalUseCase.categories[index]
            inputtedCategoryTitle = category.title
            let row = category.goals.count - 1
            selectedIndexPath = IndexPath(row: row, section: index)
            goalScreenType = .categoryAdd
            tableView.reloadData()
        }
    }
    
}

// MARK: - CategoryKeyboardViewDelegate
extension AddAndEditGoalViewController: CategoryKeyboardViewDelegate {
    
    func categoryButtonDidTapped() {
        if let alert = getPresentedVC() as? UIAlertController {
            alert.dismiss(animated: true) {
                self.present(AdditionalCategoryViewController.self) { vc in
                    vc.delegate = self
                }
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AddAndEditGoalViewController: UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.editedImage] as! UIImage
        inputtedImageData = Converter.convertToData(from: image)
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        picker.dismiss(animated: true)
        tableView.reloadData()
    }
    
}

// MARK: - configure cell
private extension AddAndEditGoalViewController {
    
    func configureTitleCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
        cell.configure(titleText: rowType.title,
                       mandatoryIsHidden: false,
                       auxiliaryText: inputtedTitle)
        return cell
    }
    
    func configureCategoryCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
        guard let goalScreenType = goalScreenType else { abort() }
        switch goalScreenType {
            case .add, .categoryAdd:
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: true,
                               auxiliaryText: inputtedCategoryTitle)
            case .sectionAdd, .edit:
                cell.configure(titleText: rowType.title,
                               mandatoryText: L10n.fixed,
                               mandatoryIsHidden: false,
                               auxiliaryText: inputtedCategoryTitle)
        }
        return cell
    }
    
    func configureMemoCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
        cell.configure(titleText: rowType.title,
                       mandatoryIsHidden: true,
                       auxiliaryText: inputtedMemo)
        return cell
    }
    
    func configurePriorityCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalPriorityTableViewCell.self)
        cell.configure(title: rowType.title,
                       priority: inputtedPriority)
        return cell
    }
    
    func configureDateCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
        let inputtedDate = getDate(type: rowType)
        let auxiliaryText = Converter.convertToString(from: inputtedDate)
        cell.configure(titleText: rowType.title,
                       mandatoryIsHidden: true,
                       auxiliaryText: auxiliaryText)
        return cell
    }
    
    func configurePhotoCell(rowType: AddAndEditGoalRowType) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalPhotoTableViewCell.self)
        let image = Converter.convertToImage(from: inputtedImageData)
        cell.configure(title: rowType.title,
                       image: image)
        return cell
    }
    
}

// MARK: - setup
private extension AddAndEditGoalViewController {
    
    func setupInputItems() {
        guard let goalScreenType = goalScreenType,
              let indexPath = selectedIndexPath else { return }
        switch goalScreenType {
            case .add, .categoryAdd:
                break
            case .sectionAdd:
                inputtedCategoryTitle = goalUseCase.categories[indexPath.section].title
            case .edit:
                let category = goalUseCase.categories[indexPath.section]
                let goal = category.goals[indexPath.row]
                inputtedTitle = goal.title
                inputtedCategoryTitle = category.title
                inputtedMemo = goal.memo
                inputtedPriority = goal.priority
                inputtedDate.due = goal.dueDate
                inputtedDate.created = goal.createdDate
                inputtedImageData = goal.imageData
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(GoalPriorityTableViewCell.self)
        tableView.registerCustomCell(GoalPhotoTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isEnabled: isMandatoryItemFilled)
    }
    
}
