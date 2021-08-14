//
//  ScreenTransitionCollectionViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/14.
//

import UIKit

final class ScreenTransitionCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.yellow.cgColor
        
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }

}
