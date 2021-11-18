//
//  AppIconTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/23.
//

import UIKit

class AppIconTableViewCell: UITableViewCell {

    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        myImageView.layer.cornerRadius = 10

    }

    func configure(title: String, image: UIImage) {
        titleLabel.text = title
        myImageView.image = image
    }

}
