//
//  StudyRecordTitleTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var inputtedTitleLabel: UILabel!
    @IBOutlet private weak var mandatoryLabel: UILabel!
    
    func configure(title: String,
                   mandatoryLabelIsHidden: Bool = false) {
        inputtedTitleLabel.text = title
        mandatoryLabel.isHidden = mandatoryLabelIsHidden
    }
    
}
