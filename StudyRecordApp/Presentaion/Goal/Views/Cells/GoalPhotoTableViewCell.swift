//
//  GoalPhotoTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/01.
//

import UIKit

final class GoalPhotoTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var unselectedLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!

    func configure(title: String, image: UIImage?) {
        titleLabel.text = title
        photoImageView.image = image
        unselectedLabel.text = L10n.unselected
        unselectedLabel.isHidden = image != nil
        unselectedLabel.layer.cornerRadius = 10
        unselectedLabel.layer.borderWidth = 0.5
        unselectedLabel.layer.borderColor = UIColor.gray.cgColor
    }

}
