//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit
import RxSwift
import RxCocoa
// MARK: - ToDo リアルタイムで同期して更新する処理も実装する(realm)

protocol EditButtonSelectable {
    var isEdit: Bool { get }
    func deleteButtonDidTappped(isEmpty: Bool)
    func baseViewLongPressDidRecognized()
}

protocol StudyRecordVCDelegate: ScreenPresentationDelegate,
    EditButtonSelectable {}

final class StudyRecordViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var registerButton: CustomButton!
    @IBOutlet private weak var tableView: UITableView!

    private lazy var viewModel: StudyRecordViewModelType = StudyRecordViewModel(
        recordUseCase: RxRecordUseCase(repository: RxRecordRepository()),
        registerButton: registerButton.rx.tap.asSignal()
    )
    private let disposeBag = DisposeBag()
    weak var delegate: StudyRecordVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRegisterButton()
        setupDescriptionLabel()
        setupBindings()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.inputs.viewWillAppear()

    }

    private func setupBindings() {
        // Input
        NotificationCenter.default.rx.notification(.reloadLocalData)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.reloadLocalData()
            })
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(.recordAdded)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.inputs.recordAdded()
            })
            .disposed(by: disposeBag)
        
        // Output
        viewModel.outputs.event
            .emit(onNext: { [weak self] event in
                guard let strongSelf = self else { return }
                switch event {
                case .presentEditStudyRecordVC(let row):
                    strongSelf.presentEditStudyRecordVC(row: row)
                case .presentAdditionalStudyRecordVC:
                    strongSelf.present(AdditionalStudyRecordViewController.self,
                                       modalPresentationStyle: .fullScreen)
                case .notifyLongPress:
                    strongSelf.delegate?.baseViewLongPressDidRecognized()
                case .presentRecordDeleteAlert(let row):
                    strongSelf.presentDeleteAlert(row: row)
                case .notifyDelete(let isEmpty):
                    strongSelf.delegate?.deleteButtonDidTappped(isEmpty: isEmpty)
                case .scrollToTop(row: let row, records: let records):
                    strongSelf.scrollToTop(row: row, records: records)
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isHiddenTableView
            .drive(onNext: { [weak self] isHidden in
                guard let strongSelf = self else { return }
                strongSelf.tableView.isHidden = isHidden
                strongSelf.delegate?.screenDidPresented(screenType: .record,
                                                        isEnabledNavigationButton: !isHidden)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.items
            .drive(
                tableView.rx.items(
                    cellIdentifier: RecordTableViewCell.identifier,
                    cellType: RecordTableViewCell.self
                )
            ) { row, element, cell in
                let isEdit = self.delegate?.isEdit ?? false
                cell.configure(record: element.record,
                               studyTime: element.studyTime)
                cell.changeMode(isEdit: isEdit,
                                isEvenIndex: row.isMultiple(of: 2))
                cell.tag = row
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }

    func reloadTableView() {
        tableView.reloadData()
    }

}

// MARK: - func
private extension StudyRecordViewController {

    func presentEditStudyRecordVC(row: Int) {
        present(EditStudyRecordViewController.self,
                modalPresentationStyle: .fullScreen) { vc in
            vc.selectedRow = row
        }
    }

    func presentDeleteAlert(row: Int) {
        let alert = Alert.create(message: L10n.doYouReallyWantToDeleteThis)
            .addAction(title: L10n.delete, style: .destructive) {
                self.viewModel.inputs.recordDeleteAlertDeleteButtonDidTapped(row: row)
                self.dismiss(animated: true)
            }
            .addAction(title: L10n.close) {
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
    }

    private func scrollToTop(row: Int, records: [Record]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let cell = self.tableView.cellForRow(
                at: IndexPath(row: row, section: 0)
            ) as? RecordTableViewCell
            let isExpanded = records[row].isExpanded
            let isLastRow = (row == records.count - 1)
            let isManyMemo = (cell?.frame.height ?? 0.0 > self.tableView.frame.height / 2)
            let isCellNil = (cell == nil)
            let shouldScrollToTop = isExpanded && (isManyMemo || isLastRow || isCellNil)
            if shouldScrollToTop {
                self.tableView.scrollToRow(at: IndexPath(row: row, section: 0),
                                           at: .top,
                                           animated: true)
            }
        }
    }

}

// MARK: - UITableViewDelegate
extension StudyRecordViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

}

// MARK: - RecordTableViewCellDelegate
extension StudyRecordViewController: RecordTableViewCellDelegate {

    func baseViewTapDidRecognized(row: Int) {
        viewModel.inputs.baseViewTapDidRecognized(row: row)
    }

    func baseViewLongPressDidRecognized() {
        viewModel.inputs.baseViewLongPressDidRecognized()
    }

    func memoButtonDidTapped(row: Int) {
        viewModel.inputs.memoButtonDidTapped(row: row)
    }

    func deleteButtonDidTappped(row: Int) {
        viewModel.inputs.deleteButtonDidTappped(row: row)
    }

}

// MARK: - setup
private extension StudyRecordViewController {

    func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.registerCustomCell(RecordTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    func setupRegisterButton() {
        registerButton.setTitle(L10n.register)
    }

    func setupDescriptionLabel() {
        descriptionLabel.text = L10n.recordedDataIsNotRegistered
    }

}
