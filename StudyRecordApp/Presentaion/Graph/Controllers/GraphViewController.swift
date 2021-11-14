//
//  GraphViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GraphVCDelegate: ScreenPresentationDelegate {}

final class GraphViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerButton: CustomButton!

    weak var delegate: GraphVCDelegate?
    private let userUseCase = UserUseCase(
        repository: UserRepository(
            dataStore: FirebaseUserDataStore()
        )
    )
    private let recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private let graphUseCase = GraphUseCase(
        repository: GraphRepository(
            dataStore: RealmGraphDataStore()
        )
    )
    private var oldRecords: [Record]?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAnonymousView()
        setupRegisterButton()
        setupDescriptionLabel()
        setupTableView()
        setObserver()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView(isHidden: recordUseCase.records.isEmpty)
        delegate?.screenDidPresented(screenType: .graph,
                                     isEnabledNavigationButton: !recordUseCase.records.isEmpty)
        reloadRows()

    }

}

// MARK: - IBAction func
private extension GraphViewController {

    @IBAction func registerButtonDidTapped(_ sender: Any) {
        delegate?.scroll(sourceScreenType: .graph,
                         destinationScreenType: .record) {
            self.present(AdditionalStudyRecordViewController.self,
                         modalPresentationStyle: .fullScreen)
        }
    }

}

// MARK: - func
private extension GraphViewController {

    func reloadRows() {
        let validation = recordUseCase.validateGraphData(oldRecords: oldRecords)
        if validation.shouldReloadAll {
            tableView.reloadData()
        } else {
            tableView.reloadRows(at: validation.indexPaths, with: .automatic)
        }
        oldRecords = recordUseCase.records
    }

    func tableView(isHidden: Bool) {
        tableView.isHidden = isHidden
    }

    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cameBackFromEditScreen),
                                               name: .graphSaveButtonDidTappped,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedThemeColor),
                                               name: .changedThemeColor,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadLocalData),
                                               name: .reloadLocalData,
                                               object: nil)
    }

    @objc
    func cameBackFromEditScreen(notification: Notification) {
        guard let isChanged = notification.userInfo?["isChanged"] as? Bool else { return }
        if isChanged {
            tableView.reloadData()
        }
    }

    @objc
    func changedThemeColor() {
        tableView.reloadData()
    }

    @objc
    func reloadLocalData() {
        tableView.reloadData()
    }

}

// MARK: - UITableViewDelegate
extension GraphViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
extension GraphViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return recordUseCase.records.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GraphTableViewCell.self)
        let record = recordUseCase.read(at: indexPath.row)
        let newRecord = Record(record: record,
                               histories: record.histories?.reversed())
        let graph = graphUseCase.graph
        cell.configure(record: newRecord, graph: graph)
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }

}

// MARK: - GraphTableViewCellDelegate
extension GraphViewController: GraphTableViewCellDelegate {

    func segmentedControlDidTapped(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index,
                                            section: 0)],
        with: .automatic)
    }

    func registerButtonDidTapped(index: Int) {
        delegate?.scroll(sourceScreenType: .graph,
                         destinationScreenType: .record) {
            self.present(EditStudyRecordViewController.self,
                         modalPresentationStyle: .fullScreen) { vc in
                vc.selectedRow = index
            }
        }
    }

}

// MARK: - setup
private extension GraphViewController {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GraphTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
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

    func setupAnonymousView() {
        let isAnonymousUser = userUseCase.isLoggedInAsAnonymously
        if isAnonymousUser {
            let anonymousView = AnonymousUserView()
            anonymousView.signUpButtonEvent = { [weak self] in
                guard let self = self else { return }
                self.present(LoginAndSignUpViewController.self,
                             modalPresentationStyle: .fullScreen) { vc in
                    vc.authViewType = .signUp
                }
            }
            anonymousView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(anonymousView)
            NSLayoutConstraint.activate([
                anonymousView.topAnchor.constraint(equalTo: self.view.topAnchor),
                anonymousView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                anonymousView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                anonymousView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
    }

}
