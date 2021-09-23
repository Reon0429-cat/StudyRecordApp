//
//  StudyRecordViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// MARK: - ToDo リアルタイムで同期して更新する処理も実装する(realm)
// MARK: - ToDo グラフカラー選択時に該当の色を丸くする(追加と編集画面でそれぞれ確認する)
// MARK: - ToDo SwiftGenを導入する

protocol StudyRecordVCDelegate: ScreenPresentationDelegate {
    var isEdit: Bool { get }
    func deleteButtonDidTappped(records: [Record])
    func baseViewLongPressDidRecognized()
}

final class StudyRecordViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    weak var delegate: StudyRecordVCDelegate?
    private let viewModel: StudyRecordViewModelType = StudyRecordViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.viewWillAppear()
        
    }
    
    private func setupBindings() {
        viewModel.outputs.event
            .drive { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .notifyDisplayed(let records):
                        self.delegate?.screenDidPresented(screenType: .record,
                                                          isEnabledNavigationButton: !records.isEmpty)
                    case .presentEditStudyRecordVC(let row):
                        self.presentEditStudyRecordVC(row: row)
                    case .notifyLongPress:
                        self.delegate?.baseViewLongPressDidRecognized()
                    case .scrollToRow(let row):
                        self.scrollToRow(row: row)
                    case .presentAlert(let row, let records):
                        self.presentAlert(row: row, records: records)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.elements
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCustomCell(with: RecordTableViewCell.self)
                let isEdit = self.delegate?.isEdit ?? false
                cell.configure(record: element.record,
                               studyTime: (todayText: element.todayText,
                                           totalText: element.totalText))
                cell.changeMode(isEdit: isEdit,
                                isEvenIndex: row.isMultiple(of: 2))
                cell.tag = row
                cell.delegate = self
                return cell
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
    
    func scrollToRow(row: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.viewModel.inputs.scrollToRow(tableView: self.tableView, row: row)
        }
    }
    
    func presentAlert(row: Int, records: [Record]) {
        let alert = Alert.create(title: LocalizeKey.doYouReallyWantToDeleteThis.localizedString())
            .addAction(title: LocalizeKey.delete.localizedString(), style: .destructive) {
                self.viewModel.inputs.deleteRecord(row: row)
                self.delegate?.deleteButtonDidTappped(records: records)
                self.dismiss(animated: true)
            }
            .addAction(title: LocalizeKey.close.localizedString()) {
                self.dismiss(animated: true)
            }
        present(alert, animated: true)
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
        tableView.delegate = self
        tableView.registerCustomCell(RecordTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
}
