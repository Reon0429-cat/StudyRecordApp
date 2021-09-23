//
//  AdditionalStudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit
import RxSwift
import RxCocoa

final class AdditionalStudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: AdditionalStudyRecordViewModelType = AdditionalStudyRecordViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        setupNavigationTopBar()
        setupTapGesture()
        setupWaveView()
        viewModel.inputs.viewDidLoad()
        
    }
    
}

// MARK: - func
private extension AdditionalStudyRecordViewController {
    
    func setupBindings() {
        setupOutputBindings()
        setupTableViewDelegate()
    }
    
    func setupOutputBindings() {
        viewModel.outputs.items
            .drive(tableView.rx.items) { tableView, row, item in
                switch item {
                    case .title(let text):
                        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                        cell.configure(titleText: LocalizeKey.Title.localizedString(),
                                       mandatoryIsHidden: false,
                                       auxiliaryText: text)
                        return cell
                    case .graphColor(let color):
                        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                        cell.configure(color: color)
                        return cell
                    case .memo(let text):
                        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                        cell.configure(titleText: LocalizeKey.Memo.localizedString(),
                                       mandatoryIsHidden: true,
                                       auxiliaryText: text)
                        return cell
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.event
            .drive { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .dismiss:
                        self.dismiss(animated: true)
                    case .presentAlert:
                        self.presentAlert()
                    case .presentAlertWithTextField(let text):
                        self.presentAlertWithTextField(text: text)
                    case .presentStudyRecordGraphColorVC:
                        self.presentStudyRecordGraphColorVC()
                    case .presentStudyRecordMemoVC(let inputtedMemo):
                        self.presentStudyRecordMemoVC(inputtedMemo: inputtedMemo)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.controlSaveButton
            .drive(onNext: subCustomNavigationBar.saveButton(isEnabled:))
            .disposed(by: disposeBag)
    }
    
    func setupTableViewDelegate() {
        tableView.rx.itemSelected
            .bind { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AdditionalStudyRecordViewModel.CellItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                switch item {
                    case .title:
                        self.viewModel.inputs.titleCellDidTapped()
                    case .graphColor:
                        self.viewModel.inputs.graphColorCellDidTapped()
                    case .memo:
                        self.viewModel.inputs.memoCellDidTapped()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func presentStudyRecordGraphColorVC() {
        present(StudyRecordGraphColorViewController.self,
                modalPresentationStyle: .overCurrentContext,
                modalTransitionStyle: .crossDissolve) { vc in
            vc.delegate = self
        }
    }
    
    func presentStudyRecordMemoVC(inputtedMemo: String) {
        present(StudyRecordMemoViewController.self,
                modalPresentationStyle: .overCurrentContext,
                modalTransitionStyle: .crossDissolve) { vc in
            vc.delegate = self
            vc.inputtedMemo = inputtedMemo
        }
    }
    
    func presentAlertWithTextField(text: String) {
        let alert = Alert.create(title: LocalizeKey.Title.localizedString())
            .setTextField { textField in
                textField.tintColor = .dynamicColor(light: .black, dark: .white)
                textField.text = text
                textField.delegate = self
            }
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .destructive) {
                self.viewModel.inputs.alertWithTextFieldCloseButtonDidTapped()
            }
                       .addAction(title: LocalizeKey.add.localizedString()) {
                           self.viewModel.inputs.alertWithTextFieldAddButtonDidTapped()
                       }
        present(alert, animated: true)
    }
    
    func presentAlert() {
        let alert = Alert.create(title: LocalizeKey.doYouWantToCloseWithoutSaving.localizedString())
            .addAction(title: LocalizeKey.close.localizedString(),
                       style: .destructive) {
                self.dismiss(animated: true)
            }
                       .addAction(title: LocalizeKey.save.localizedString()) {
                           self.viewModel.inputs.saveButtonDidTapped()
                       }
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDelegate
extension AdditionalStudyRecordViewController: UITableViewDelegate {
    
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

// MARK: - StudyRecordGraphColorVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordGraphColorVCDelegate {
    
    func graphColorDidSelected(color: UIColor) {
        viewModel.inputs.graphColorDidSelected(color: color)
    }
    
}

// MARK: - StudyRecordMemoVCDelegate
extension AdditionalStudyRecordViewController: StudyRecordMemoVCDelegate {
    
    func savedMemo(memo: String) {
        viewModel.inputs.savedMemo(memo: memo)
    }
    
}

// MARK: - UITextFieldDelegate
extension AdditionalStudyRecordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputs.textFieldDidChangeSelection(textField)
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension AdditionalStudyRecordViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() {
        viewModel.inputs.saveButtonDidTapped()
    }
    
    func dismissButtonDidTapped() {
        viewModel.inputs.dismissButtonDidTapped()
    }
    
    var navTitle: String {
        return LocalizeKey.Add.localizedString()
    }
    
}

// MARK: - setup
private extension AdditionalStudyRecordViewController {
    
    func setupTableView() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.tableFooterView = UIView()
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

