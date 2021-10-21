//
//  AppVersionTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/22.
//

import UIKit

final class AppVersionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    func configure(title: String, version: String) {
        titleLabel.text = title
        descriptionLabel.text = version
    }
    
}
