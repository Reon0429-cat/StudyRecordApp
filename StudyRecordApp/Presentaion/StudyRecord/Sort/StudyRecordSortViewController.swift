//
//  StudyRecordSortViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/08.
//

import UIKit

final class StudyRecordSortViewController: UIViewController {

    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomWaveView: WaveView!

    private let recordUseCase = RecordUseCase(
        repository: RecordRepository()
    )
    private var records: [Record] {
        recordUseCase.records
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSubCustomNavigationBar()
        setupWaveViews()

    }

}

// MARK: - SortableViewControllerProtocol
extension StudyRecordSortViewController: SortableViewControllerProtocol {}

// MARK: - UITableViewDelegate
extension StudyRecordSortViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _tableView(tableView, heightForRowAt: indexPath)
    }

}

// MARK: - UITableViewDataSource
extension StudyRecordSortViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        _tableView(tableView, didSelectRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        records.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == records.count - 1 {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            let tableBottomMaxY = tableView.rectForRow(at: indexPath).maxY
            let shouldHideWave = bottomWaveView.frame.minY - bottomWaveView.frame.height < tableBottomMaxY
            tableView.isScrollEnabled = shouldHideWave
            bottomWaveView.isHidden = shouldHideWave
        }

        let cell = tableView.dequeueReusableCustomCell(with: StudyRecordSortTableViewCell.self)
        let record = records[indexPath.row]
        cell.configure(title: record.title)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        recordUseCase.sort(from: sourceIndexPath,
                           to: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return _tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return _tableView(tableView, viewForHeaderInSection: section)
    }

}

// MARK: - UITableViewDragDelegate
extension StudyRecordSortViewController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        let recordTitle = records[indexPath.row].title
        return _tableView(tableView,
                          itemsForBeginning: session,
                          at: indexPath,
                          title: recordTitle)
    }

}

// MARK: - UITableViewDropDelegate
extension StudyRecordSortViewController: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView,
                   dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return _tableView(tableView,
                          dropSessionDidUpdate: session,
                          withDestinationIndexPath: destinationIndexPath)
    }

    func tableView(_ tableView: UITableView,
                   performDropWith coordinator: UITableViewDropCoordinator) {}

}

// MARK: - SubCustomNavigationBarDelegate
extension StudyRecordSortViewController: SubCustomNavigationBarDelegate {

    func saveButtonDidTapped() {}

    func dismissButtonDidTapped() {
        NotificationCenter.default.post(name: .recordAdded, object: nil)
        dismiss(animated: true)
    }

    var navTitle: String {
        return L10n.largeSort
    }

}

// MARK: - setup
private extension StudyRecordSortViewController {

    func setupTableView() {
        _setup(tableView: tableView, vc: self)
        tableView.registerCustomCell(StudyRecordSortTableViewCell.self)
    }

    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }

    func setupWaveViews() {
        bottomWaveView.create(isFill: false, marginY: 30, isShuffled: true)
    }

}
