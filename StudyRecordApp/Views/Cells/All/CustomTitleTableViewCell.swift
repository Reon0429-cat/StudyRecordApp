//
//  CustomTitleTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/13.
//

import UIKit

final class CustomTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var mandatoryLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var auxiliaryLabel: UILabel!
    
    func configure(titleText: String,
                   mandatoryText: String = LocalizeKey.mandatory.localizedString(),
                   mandatoryIsHidden: Bool = true,
                   auxiliaryText: String = "") {
        titleLabel.text = titleText
        mandatoryLabel.isHidden = mandatoryIsHidden
        mandatoryLabel.text = mandatoryText
        auxiliaryLabel.text = auxiliaryText
    }
    
}
