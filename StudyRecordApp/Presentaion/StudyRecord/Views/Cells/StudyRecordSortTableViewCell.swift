//
//  StudyRecordSortTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/08.
//

import UIKit

final class StudyRecordSortTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var listImageButton: UIButton!
    @IBOutlet private weak var achievedLabel: UILabel!

    func configure(title: String,
                   isAchieved: Bool = false) {
        titleLabel.text = title
        let image = UIImage(systemName: .listBullet)
        listImageButton.setImage(image.setColor(.dynamicColor(light: .black, dark: .white)))
        if isAchieved {
            achievedLabel.text = L10n.achieved
        } else {
            achievedLabel.text = ""
        }
    }

}
