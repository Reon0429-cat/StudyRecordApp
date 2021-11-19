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

    private lazy var viewModel: AdditionalStudyRecordViewModelType = AdditionalStudyRecordViewModel(
        recordUseCase: RxRecordUseCase(repository: RxRecordRepository())
    )
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationTopBar()
        setupTapGesture()
        setupWaveView()
        setupBindings()
        viewModel.inputs.viewDidLoad()

    }

    private func setupBindings() {
        // Input
        Observable
            .zip(
                tableView.rx.itemSelected,
                tableView.rx.modelSelected(AdditionalStudyRecordViewModel.Item.self)
            )
            .bind { [weak self] indexPath, item in
                guard let strongSelf = self else { return }
                strongSelf.tableView.deselectRow(at: indexPath, animated: true)
                strongSelf.viewModel.inputs.itemDidSelected(item: item)
            }
            .disposed(by: disposeBag)

        // Output
        viewModel.outputs.items
            .drive(tableView.rx.items) { tableView, row, item in
                switch item {
                case .title(let title):
                    let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                    cell.configure(titleText: L10n.largeTitle,
                                   mandatoryIsHidden: false,
                                   auxiliaryText: title,
                                   isMemo: false)
                    return cell
                case .graphColor(let color):
                    let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                    cell.configure(color: color)
                    return cell
                case .memo(let memo):
                    let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                    cell.configure(titleText: L10n.largeMemo,
                                   mandatoryIsHidden: true,
                                   auxiliaryText: memo,
                                   isMemo: true)
                    return cell
                }
            }
            .disposed(by: disposeBag)

        viewModel.outputs.event
            .emit(onNext: { [weak self] event in
                guard let strongSelf = self else { return }
                switch event {
                case .dismiss:
                    strongSelf.dismiss(animated: true)
                case .presentStudyRecordGraphColorVC:
                    strongSelf.presentStudyRecordGraphColorVC()
                case .presentStudyRecordMemoVC(let memo):
                    strongSelf.presentStudyRecordMemoVC(memo: memo)
                case .presentAlert:
                    strongSelf.presentAlert()
                case .presentAlertWithTextField(let text):
                    strongSelf.showAlertWithTextField(inputtedTitle: text)
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isEnabledSaveButton
            .drive(onNext: { [weak self] isEnabled in
                guard let strongSelf = self else { return }
                strongSelf.subCustomNavigationBar.saveButton(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)

    }

}

// MARK: - func
private extension AdditionalStudyRecordViewController {

    func presentAlert() {
        let alert = Alert.create(message: L10n.doYouWantToCloseWithoutSaving)
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.save) {
                self.viewModel.inputs.saveAlertSaveButtonDidTapped()
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }

    func showAlertWithTextField(inputtedTitle: String) {
        let alert = Alert.create(title: L10n.largeTitle)
            .setTextField { textField in
                textField.tintColor = .dynamicColor(light: .black, dark: .white)
                textField.text = inputtedTitle
                textField.delegate = self
            }
            .addAction(title: L10n.close) {
                self.viewModel.inputs.textFieldAlertCloseButtonDidTapped()
            }
            .addAction(title: L10n.add) {
                self.viewModel.inputs.textFieldAlertAddButtonDidTapped(title: inputtedTitle)
                self.tableView.reloadData()
            }
        present(alert, animated: true)
    }

    func presentStudyRecordGraphColorVC() {
        present(StudyRecordGraphColorViewController.self,
                modalPresentationStyle: .overCurrentContext,
                modalTransitionStyle: .crossDissolve) { vc in
            vc.delegate = self
        }
    }

    func presentStudyRecordMemoVC(memo: String) {
        present(StudyRecordMemoViewController.self,
                modalPresentationStyle: .overCurrentContext,
                modalTransitionStyle: .crossDissolve) { vc in
            vc.inputtedMemo = memo
            vc.delegate = self
        }
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
        viewModel.inputs.textFieldDidChangeSelection(text: textField.text)
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
        return L10n.largeAdd
    }

}

// MARK: - setup
private extension AdditionalStudyRecordViewController {

    func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        tableView.registerCustomCell(StudyRecordGraphColorTableViewCell.self)
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    func setupNavigationTopBar() {
        subCustomNavigationBar.delegate = self
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
