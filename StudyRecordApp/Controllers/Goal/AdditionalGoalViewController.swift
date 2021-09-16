//
//  AdditionalGoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class AdditionalGoalViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    
    enum RowType: Int, CaseIterable {
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
                    return LocalizeKey.Title.localizedString()
                case .category:
                    return LocalizeKey.Category.localizedString()
                case .memo:
                    return LocalizeKey.Memo.localizedString()
                case .priority:
                    return LocalizeKey.Priority.localizedString()
                case .dueDate:
                    return LocalizeKey.dueDate.localizedString()
                case .createdDate:
                    return LocalizeKey.createdDate.localizedString()
                case .photo:
                    return LocalizeKey.photo.localizedString()
            }
        }
    }
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var inputtedMemo = ""
    private var inputtedImageData: Data?
    private var inputtedPriority = Priority(mark: .star, number: .one)
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
    private func getDateType(type: RowType) -> GoalDateType {
        switch type {
            case .createdDate: return .created
            case .dueDate: return .due
            default: fatalError("typeが不適")
        }
    }
    private func getDate(type: RowType) -> Date {
        switch type {
            case .createdDate: return inputtedDate.created
            case .dueDate: return inputtedDate.due
            default: fatalError("typeが不適")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSubCustomNavigationBar()
        
    }
    
}

// MARK: - func
private extension AdditionalGoalViewController {
    
    func showAlertWithTextField() {
        let alert = Alert.create(title: LocalizeKey.Title.localizedString())
            .setTextField { textField in
                textField.text = self.inputtedTitle
                textField.delegate = self
            }
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .destructive) {
                self.inputtedTitle = self.oldInputtedTitle
            }
            .addAction(title: LocalizeKey.add.localizedString()) {
                self.oldInputtedTitle = self.inputtedTitle
                self.tableView.reloadData()
            }
        present(alert, animated: true)
    }
    
    func showAlert() {
        let alert = Alert.create(title: LocalizeKey.doYouWantToCloseWithoutSaving.localizedString())
            .addAction(title: LocalizeKey.close.localizedString(), style: .destructive) {
                self.dismiss(animated: true)
            }
            .addAction(title: LocalizeKey.save.localizedString()) {
                self.saveGoal()
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
    func saveGoal() {
        let goal = Goal(title: inputtedTitle,
                        category: Category(title: ""),
                        memo: inputtedMemo,
                        priority: inputtedPriority,
                        dueDate: inputtedDate.due,
                        createdDate: inputtedDate.created,
                        imageData: inputtedImageData)
        goalUseCase.create(goal: goal)
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
    
    func presentGoalTimeVC(rowType: RowType) {
        present(GoalTimeViewController.self) { vc in
            vc.delegate = self
            vc.dateType = self.getDateType(type: rowType)
            vc.inputtedDate = self.getDate(type: rowType)
            self.halfModalPresenter.viewController = vc
        }
    }
    
    func presentPhotoActionSheet(row: Int) {
        var alert = Alert.create(preferredStyle: .actionSheet)
            .addAction(title: LocalizeKey.takeAPhoto.localizedString()) {
                self.presentTo(.camera)
            }
            .addAction(title: LocalizeKey.selectFromLibrary.localizedString()) {
                self.presentTo(.photoLibrary)
            }
        if inputtedImageData != nil {
            alert = alert.addAction(title: LocalizeKey.deletePhoto.localizedString(),
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
        alert = alert.addAction(title: LocalizeKey.close.localizedString(),
                                style: .cancel)
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension AdditionalGoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = RowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                showAlertWithTextField()
            case .category:
                break
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
        if RowType(rawValue: indexPath.row) == .photo && inputtedImageData != nil {
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
extension AdditionalGoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = RowType.allCases[indexPath.row]
        switch rowType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: false,
                               auxiliaryText: inputtedTitle)
                return cell
            case .category:
                return UITableViewCell()
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: true,
                               auxiliaryText: inputtedMemo)
                return cell
            case .priority:
                let cell = tableView.dequeueReusableCustomCell(with: GoalPriorityTableViewCell.self)
                cell.configure(title: rowType.title,
                               priority: inputtedPriority)
                return cell
            case .createdDate, .dueDate:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                let inputtedDate = getDate(type: rowType)
                // MARK: - ToDo ローカライズする
                let auxiliaryText = Converter.convertToString(from: inputtedDate,
                                                              format: "yyyy年M月d日")
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: true,
                               auxiliaryText: auxiliaryText)
                return cell
            case .photo:
                let cell = tableView.dequeueReusableCustomCell(with: GoalPhotoTableViewCell.self)
                let image = Converter.convertToImage(from: inputtedImageData)
                cell.configure(title: rowType.title,
                               image: image)
                return cell
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalGoalViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        subCustomNavigationBar.saveButton(isEnabled: isMandatoryItemFilled)
    }
    
}

// MARK: - GoalPriorityVCDelegate
extension AdditionalGoalViewController: GoalPriorityVCDelegate {
    
    func addButtonDidTapped(priority: Priority) {
        inputtedPriority = priority
        tableView.reloadData()
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension AdditionalGoalViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        tableView.reloadData()
    }
    
}

// MARK: - GoalTimeVCDelegate
extension AdditionalGoalViewController: GoalTimeVCDelegate {
    
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
extension AdditionalGoalViewController: SubCustomNavigationBarDelegate {
    
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
        return LocalizeKey.Add.localizedString()
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AdditionalGoalViewController: UIImagePickerControllerDelegate,
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

// MARK: - setup
private extension AdditionalGoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(GoalPriorityTableViewCell.self)
        tableView.registerCustomCell(GoalPhotoTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isEnabled: false)
    }
    
}
