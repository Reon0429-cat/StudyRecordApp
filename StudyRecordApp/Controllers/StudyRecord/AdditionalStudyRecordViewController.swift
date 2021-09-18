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
    
    private enum CellType: Int, CaseIterable {
        case title
        case graphColor
        case memo
    }
    private let viewModel: AdditionalStudyRecordViewModelType = AdditionalStudyRecordViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        setupNavigationTopBar()
        setupTapGesture()
        setupWaveView()
        
    }
    
    private func setupBindings() {
        viewModel.outputs.event
            .drive { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .presentAlert(let alert):
                        self.present(alert, animated: true)
                    case .presentVC(let vc):
                        self.present(vc, animated: true)
                    case .dismiss:
                        self.dismiss(animated: true)
                    case .reloadData:
                        self.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.controlSaveButton
            .drive { isEnabled in
                self.subCustomNavigationBar.saveButton(isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)
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
                viewModel.inputs.titleCellDidTapped(vc: self)
            case .graphColor:
                viewModel.inputs.graphColorCellDidTapped(vc: self)
            case .memo:
                viewModel.inputs.memoCellDidTapped(vc: self)
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
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = CellType(rawValue: indexPath.row)!
        switch cellType {
            case .title:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: LocalizeKey.Title.localizedString(),
                               mandatoryIsHidden: false,
                               auxiliaryText: viewModel.outputs.titleText)
                return cell
            case .graphColor:
                let cell = tableView.dequeueReusableCustomCell(with: StudyRecordGraphColorTableViewCell.self)
                cell.configure(color: viewModel.outputs.graphColor)
                return cell
            case .memo:
                let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
                cell.configure(titleText: LocalizeKey.Memo.localizedString(),
                               mandatoryIsHidden: true,
                               auxiliaryText: viewModel.outputs.memoText)
                return cell
        }
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
        tableView.delegate = self
        tableView.dataSource = self
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

