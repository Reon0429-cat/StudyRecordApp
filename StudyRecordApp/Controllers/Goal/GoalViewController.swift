//
//  GoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GoalVCDelegate: AnyObject {
    func screenDidPresented(index: Int)
}

final class GoalViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    weak var delegate: GoalVCDelegate?
    private enum SegmentType: Int {
        case category
        case simple
    }
    private var goalUseCase = GoalUseCase(
        repository: GoalRepository(
            dataStore: RealmGoalDataStore()
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSegmentedControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.screenDidPresented(index: self.view.tag)
        tableView.reloadData()
        
    }
    
}

// MARK: - IBAction func
private extension GoalViewController {
    
    @IBAction func segmentedControlDidSelected(_ sender: UISegmentedControl) {
        guard let segmentType = SegmentType(rawValue: sender.selectedSegmentIndex) else { return }
        switch segmentType {
            case .category:
                break
            case .simple:
                break
        }
    }
    
}

// MARK: - UITableViewDelegate
extension GoalViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

// MARK: - UITableViewDataSource
extension GoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return goalUseCase.goals.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCustomCell(with: GoalTableViewCell.self)
        let goal = goalUseCase.goals[indexPath.row]
        let createdDateString = Converter.convertToString(from: goal.createdDate, format: "yyyy年M月d日")
        let dueDateString = Converter.convertToString(from: goal.dueDate, format: "yyyy年M月d日")
        let title = "\(createdDateString), \(dueDateString)"
        let image = Converter.convertToImage(from: goal.imageData)
        cell.configure(title: title, image: image)
        return cell
    }
    
}

// MARK: - setup
private extension GoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCustomCell(GoalTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func setupSegmentedControl() {
        let index = 0
        segmentedControl.create(["カテゴリ", "シンプル"], selectedIndex: index)
    }
    
}
