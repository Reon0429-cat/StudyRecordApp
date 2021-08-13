//
//  StudyRecordCustomTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/13.
//

import UIKit

final class StudyRecordCustomTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var mandatoryLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var auxiliaryLabel: UILabel!
    
    func configure(titleText: String,
                   mandatoryIsHidden: Bool,
                   auxiliaryText: String) {
        titleLabel.text = titleText
        mandatoryLabel.isHidden = mandatoryIsHidden
        auxiliaryLabel.text = auxiliaryText
    }
    
}
