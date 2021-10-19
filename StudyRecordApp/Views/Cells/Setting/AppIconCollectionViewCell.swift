//
//  AppIconCollectionViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

final class AppIconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = 10
        
    }
    
    func configure(image: UIImage) {
        iconImageView.image = image
    }
    
}
