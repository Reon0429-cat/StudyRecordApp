//
//  ScreenTransitionCollectionViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/14.
//

import UIKit

final class ScreenTransitionCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rippleView: RippleView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(title: String) {
        titleLabel.text = title
        titleLabel.textColor = .white
        rippleView.layer.cornerRadius = 20
        rippleView.setGradation()
    }

}
