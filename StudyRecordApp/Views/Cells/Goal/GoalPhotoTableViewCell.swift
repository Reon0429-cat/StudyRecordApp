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
        
        if image == nil {
            unselectedLabel.isHidden = false
            photoImageView.image = nil
        } else {
            unselectedLabel.isHidden = true
            photoImageView.image = image
        }
        unselectedLabel.layer.cornerRadius = 10
        unselectedLabel.layer.borderWidth = 0.5
        unselectedLabel.layer.borderColor = UIColor.gray.cgColor
    }
    
}
