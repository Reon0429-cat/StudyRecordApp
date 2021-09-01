//
//  AdditionalGoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

// MARK: - ToDo トリミングサイズで貼れるようにする
// MARK: - ToDo 写真を保存できるようにする
// MARK: - ToDo 写真を撮るを実装する

final class AdditionalGoalViewController: UIViewController {
    
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var dismissButton: NavigationButton!
    @IBOutlet private weak var saveButton: NavigationButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum RowType: Int, CaseIterable {
        case title
        case category
        case memo
        case priority
        case dueDate
        case createdDate
        case photo
        
        var title: String {
            switch self {
                case .title: return "タイトル"
                case .category: return "カテゴリー"
                case .memo: return "メモ"
                case .priority: return "優先度"
                case .dueDate: return "期日"
                case .createdDate: return "作成日"
                case .photo: return "写真"
            }
        }
    }
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var inputtedMemo = ""
    private var inputtedImage: UIImage?
    private var inputtedPriority = Priority(mark: .star, number: .one)
    private var halfModalPresenter = HalfModalPresenter()
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty
    }
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSaveButton()
        setupDismissButton()
        setupWaveView()
        
    }
    
}

// MARK: - func
private extension AdditionalGoalViewController {
    
    func presentAlertWithTextField() {
        let alert = UIAlertController(title: "タイトル", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.inputtedTitle
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "閉じる", style: .destructive) { _ in
            self.inputtedTitle = self.oldInputtedTitle
        })
        alert.addAction(UIAlertAction(title: "追加", style: .default) { _ in
            self.oldInputtedTitle = self.inputtedTitle
            self.tableView.reloadData()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "保存せずに閉じますか", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "保存する", style: .default) { _ in
            self.saveGoal()
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func saveGoal() {
        let goal = Goal(title: inputtedTitle,
                        category: Category(title: "カテゴリー"),
                        memo: inputtedMemo,
                        priority: inputtedPriority,
                        dueDate: Date(),
                        createdDate: Date())
        goalUseCase.create(goal: goal)
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
        }
    }
    
    func presentLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.modalPresentationStyle = .fullScreen
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func presentStudyRecordMemoVC() {
        let studyRecordMemoVC = StudyRecordMemoViewController.instantiate()
        studyRecordMemoVC.modalPresentationStyle = .overCurrentContext
        studyRecordMemoVC.modalTransitionStyle = .crossDissolve
        studyRecordMemoVC.inputtedMemo = inputtedMemo
        studyRecordMemoVC.delegate = self
        present(studyRecordMemoVC, animated: true, completion: nil)
    }
    
    func presentGoalPriorityVC() {
        let goalPriorityVC = GoalPriorityViewController.instantiate()
        goalPriorityVC.delegate = self
        goalPriorityVC.inputtedPriority = inputtedPriority
        halfModalPresenter.viewController = goalPriorityVC
        present(goalPriorityVC, animated: true, completion: nil)
    }
    
    func presentPhotoActionSheet(row: Int) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "写真を撮る",
                                      style: .default) { _ in
            self.presentCamera()
        })
        alert.addAction(UIAlertAction(title: "ライブラリから選択する",
                                      style: .default) { _ in
            self.presentLibrary()
        })
        if inputtedImage != nil {
            alert.addAction(UIAlertAction(title: "写真を削除する",
                                          style: .destructive) { _ in
                self.inputtedImage = nil
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [IndexPath(row: row,
                                                             section: 0)],
                                              with: .automatic)
                    self.tableView.endUpdates()
                }
            })
        }
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel))
        self.present(alert, animated: true, completion: nil)
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
                presentAlertWithTextField()
            case .category: break
            case .memo:
                presentStudyRecordMemoVC()
            case .priority:
                presentGoalPriorityVC()
            case .dueDate: break
            case .createdDate: break
            case .photo:
                presentPhotoActionSheet(row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if RowType(rawValue: indexPath.row) == .photo && inputtedImage != nil {
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
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: false,
                               auxiliaryText: inputtedTitle)
                return cell
            case .category: return UITableViewCell()
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordCustomTableViewCell.self)
                cell.configure(titleText: rowType.title,
                               mandatoryIsHidden: true,
                               auxiliaryText: inputtedMemo)
                return cell
            case .priority:
                let cell = tableView.dequeueReusableCustomCell(with: GoalPriorityTableViewCell.self)
                cell.configure(title: rowType.title,
                               priority: inputtedPriority)
                return cell
            case .dueDate: return UITableViewCell()
            case .createdDate: return UITableViewCell()
            case .photo:
                let cell = tableView.dequeueReusableCustomCell(with: GoalPhotoTableViewCell.self)
                cell.configure(title: rowType.title,
                               image: inputtedImage)
                return cell
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalGoalViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        saveButton.isEnabled(isMandatoryItemFilled)
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

// MARK: - NavigationButtonDelegate
extension AdditionalGoalViewController: NavigationButtonDelegate {
    
    func titleButtonDidTapped(type: NavigationButtonType) {
        if type == .save {
            saveGoal()
            self.dismiss(animated: true, completion: nil)
        }
        if type == .dismiss {
            if isMandatoryItemFilled {
                presentAlert()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension AdditionalGoalViewController: UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as! UIImage
        inputtedImage = image
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}

// MARK: - setup
private extension AdditionalGoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(StudyRecordCustomTableViewCell.self)
        tableView.registerCustomCell(GoalPriorityTableViewCell.self)
        tableView.registerCustomCell(GoalPhotoTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func setupSaveButton() {
        saveButton.delegate = self
        saveButton.type = .save
        saveButton.isEnabled(false)
        saveButton.backgroundColor = .clear
    }
    
    func setupDismissButton() {
        dismissButton.delegate = self
        dismissButton.type = .dismiss
        dismissButton.backgroundColor = .clear
    }
    
    func setupWaveView() {
        topWaveView.create(isFill: true, marginY: 60)
    }
    
}
