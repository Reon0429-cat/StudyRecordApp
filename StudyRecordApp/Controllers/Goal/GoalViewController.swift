//
//  GoalViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GoalVCDelegate: AnyObject {
    func viewWillAppear(index: Int)
}

final class GoalViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    weak var delegate: GoalVCDelegate?
    private enum SegmentType: Int {
        case category
        case simple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSegmentedControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(index: self.view.tag)
        
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
    
}

// MARK: - UITableViewDataSource
extension GoalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCustomCell(with: <#T##T.Type#>)
        return UITableViewCell()
    }
    
}

// MARK: - setup
private extension GoalViewController {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.registerCustomCell(<#T##cellType: T.Type##T.Type#>)
        tableView.tableFooterView = UIView()
    }
    
    func setupSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                                for: .selected)
        segmentedControl.selectedSegmentTintColor = .black
    }
    
}
