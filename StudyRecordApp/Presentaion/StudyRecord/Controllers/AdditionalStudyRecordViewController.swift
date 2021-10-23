//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

final class AdditionalStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var tableView: UITableView!
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
    }
    private let cellTypes = CellType.allCases
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var inputtedTitle = ""
    private var oldInputtedTitle = ""
    private var selectedGraphColor: UIColor = .clear
    private var inputtedMemo = ""
    private var isMandatoryItemFilled: Bool {
        !inputtedTitle.isEmpty && selectedGraphColor != .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationTopBar()
        setupTapGesture()
        setupWaveView()
        
    }
    
}

// MARK: - func
private extension AdditionalStudyRecordViewController {
    
    func controlSaveButton() {
        subCustomNavigationBar.saveButton(isEnabled: isMandatoryItemFilled)
    }
    
    func saveRecord() {
        let record = Record(title: inputtedTitle,
                            histories: nil,
                            isExpanded: false,
                            graphColor: GraphColor(color: selectedGraphColor),
                            memo: inputtedMemo,
                            yearID: UUID().uuidString,
                            monthID: UUID().uuidString,
                            order: recordUseCase.records.count,
                            identifier: UUID().uuidString)
        recordUseCase.save(record: record)
    }
    
    func showAlert() {
        let alert = Alert.create(message: L10n.doYouWantToCloseWithoutSaving)
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.save) {
                self.saveRecord()
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }
    
    func showAlertWithTextField() {
        let alert = Alert.create(title: L10n.largeTitle)
            .setTextField { textField in
                textField.tintColor = .dynamicColor(light: .black, dark: .white)
                textField.text = self.inputtedTitle
                textField.delegate = self
            }
            .addAction(title: L10n.close) {
                self.inputtedTitle = self.oldInputtedTitle
            }
            .addAction(title: L10n.add) {
                self.oldInputtedTitle = self.inputtedTitle
                self.tableView.reloadData()
            }
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension AdditionalStudyRecordViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                showAlertWithTextField()
            case .graphColor:
                present(StudyRecordGraphColorViewController.self,
                        modalPresentationStyle: .overCurrentContext,
                        modalTransitionStyle: .crossDissolve) { vc in
                    vc.delegate = self
                }
            case .memo:
                present(StudyRecordMemoViewController.self,
                        modalPresentationStyle: .overCurrentContext,
                        modalTransitionStyle: .crossDissolve) { vc in
                    vc.inputtedMemo = self.inputtedMemo
                    vc.delegate = self
                }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
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
extension AdditionalStudyRecordViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: L10n.largeTitle,
                               mandatoryIsHidden: false,
                               auxiliaryText: inputtedTitle)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: selectedGraphColor)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: L10n.largeMemo,
                               mandatoryIsHidden: true,
                               auxiliaryText: inputtedMemo)
                return cell
        }
    }
    
}

// MARK: - StudyRecordGraphColorVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        selectedGraphColor = color
        tableView.reloadData()
        controlSaveButton()
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        inputtedMemo = memo
        tableView.reloadData()
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        inputtedTitle = textField.text ?? ""
        controlSaveButton()
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension AdditionalStudyRecordViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() {
        saveRecord()
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
        return L10n.largeAdd
    }
    
}

// MARK: - setup
private extension AdditionalStudyRecordViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func setupNavigationTopBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isEnabled: false)
    }
    
    func setupTapGesture() {
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setupWaveView() {
        bottomWaveView.create(isFill: false, marginY: 30, isShuffled: true)
    }
    
}

