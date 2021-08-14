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
        
        backgroundColor = .red
        
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }

}
