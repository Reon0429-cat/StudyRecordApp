//
//  StudyRecordGraphColorTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var unselectedLabel: UILabel!
    @IBOutlet private weak var mandatoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGraphColor()
        
    }
    
    private func setupGraphColor() {
        graphColorView.layer.cornerRadius = 10
        graphColorView.layer.borderWidth = 0.5
        graphColorView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configure(color: UIColor) {
        graphColorView.backgroundColor = color
        let isWhite = color.redValue == 1.0
            && color.greenValue == 1.0
            && color.blueValue == 1.0
            && color.alphaValue == 1.0
        unselectedLabel.isHidden = !isWhite
        unselectedLabel.text = LocalizeKey.unselected.localizedString()
        mandatoryLabel.text = LocalizeKey.mandatory.localizedString()
        titleLabel.text = LocalizeKey.graphColor.localizedString()
    }
    
}
