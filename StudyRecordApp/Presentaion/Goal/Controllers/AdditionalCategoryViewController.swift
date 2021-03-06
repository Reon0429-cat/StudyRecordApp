//
//  AdditionalCategoryViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/18.
//

import UIKit

protocol AdditionalCategoryVCDelegate: AnyObject {
    func saveButtonDidTapped(at index: Int?)
}

final class AdditionalCategoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    weak var delegate: AdditionalCategoryVCDelegate?

    private let goalUseCase = GoalUseCase(
        repository: GoalRepository()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupDismissButton()
        setupSaveButton()

    }

}

// MARK: - IBAction func
private extension AdditionalCategoryViewController {

    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let index = tableView.indexPathForSelectedRow?.row
        delegate?.saveButtonDidTapped(at: index)
        dismiss(animated: true)
    }

    @IBAction func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - UITableViewDelegate
extension AdditionalCategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

// MARK: - UITableViewDataSource
extension AdditionalCategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return goalUseCase.categories.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: CustomTitleTableViewCell.self)
        let title = goalUseCase.categories[indexPath.row].title
        cell.configure(titleText: title, isMemo: false)
        return cell
    }

}

// MARK: - setup
private extension AdditionalCategoryViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerCustomCell(CustomTitleTableViewCell.self)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    func setupDismissButton() {
        dismissButton.setTitle(L10n.close)
    }

    func setupSaveButton() {
        saveButton.setTitle(L10n.decision)
    }

}
