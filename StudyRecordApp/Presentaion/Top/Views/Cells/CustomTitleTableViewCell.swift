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
                   mandatoryText: String = L10n.mandatory,
                   mandatoryIsHidden: Bool = true,
                   auxiliaryText: String = "",
                   isMemo: Bool) {
        titleLabel.text = titleText
        mandatoryLabel.isHidden = mandatoryIsHidden
        mandatoryLabel.text = mandatoryText
        if isMemo {
            auxiliaryLabel.isHidden = auxiliaryText.isEmpty
            if !auxiliaryText.isEmpty {
                auxiliaryLabel.text = "..."
            }
        } else {
            auxiliaryLabel.text = auxiliaryText
        }
    }
    
}
