//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    
    static let height: CGFloat = 40
    
    func configure(category: Category) {
        titleLabel.text = category.title
    }

    @IBAction private func addButtonDidTapped(_ sender: Any) {
        
    }
    
}
