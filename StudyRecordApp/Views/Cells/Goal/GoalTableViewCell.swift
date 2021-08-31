//
//  GoalTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
