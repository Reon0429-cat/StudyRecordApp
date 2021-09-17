//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

protocol GoalHeaderViewDelegate: AnyObject {
    func addButtonDidTapped(section: Int)
    func foldingButtonDidTapped(section: Int)
}

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var foldingButton: UIButton!
    
    static let height: CGFloat = 40
    weak var delegate: GoalHeaderViewDelegate?
    
    func configure(category: Category) {
        setupTitleLabel(category: category)
        setupFoldingButton(category: category)
    }
    
}

// MARK: - IBAction func
private extension GoalHeaderView {
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        delegate?.addButtonDidTapped(section: self.tag)
    }
    
    @IBAction func foldingButtonDidTapped(_ sender: Any) {
        delegate?.foldingButtonDidTapped(section: self.tag)
    }
    
}

// MARK: - setup
private extension GoalHeaderView {
    
    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }
    
    func setupFoldingButton(category: Category) {
        let title = category.isExpanded ? "▲" : "▼"
        foldingButton.setTitle(title)
    }
    
}
