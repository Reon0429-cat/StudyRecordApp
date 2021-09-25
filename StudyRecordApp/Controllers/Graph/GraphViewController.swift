//
//  GraphViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GraphVCDelegate: ScreenPresentationDelegate {
    
}

final class GraphViewController: UIViewController {
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerButton: CustomButton!
    
    weak var delegate: GraphVCDelegate?
    private var recordUseCase = RecordUseCase(
        repository: RecordRepository(
            dataStore: RealmRecordDataStore()
        )
    )
    private var graphUseCase = GraphUseCase(
        repository: GraphRepository(
            dataStore: RealmGraphDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.reloadData()
        
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
    
    func tableView(isHidden: Bool) {
        tableView.isHidden = isHidden
    }
    
    func setObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(cameBackFromEditScreen),
                                               name: .graphSaveButtonDidTappped,
                                               object: nil)
    }
    
    @objc
    func cameBackFromEditScreen() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate
extension GraphViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
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
        let newRecord = Record(title: record.title,
                               histories: record.histories?.reversed(),
                               isExpanded: record.isExpanded,
                               graphColor: record.graphColor,
                               memo: record.memo,
                               yearID: record.yearID,
                               monthID: record.monthID,
                               order: record.order,
                               uuidString: record.uuidString)
        let graph = graphUseCase.graph
        cell.configure(record: newRecord, graph: graph)
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    
}

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
        tableView.tableFooterView = UIView()
    }
    
    func setupRegisterButton() {
        registerButton.setTitle(LocalizeKey.Register.localizedString())
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.text = LocalizeKey.recordedDataIsNotRegistered.localizedString()
    }
    
}


