//
//  StudyRecordGraphColorTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var unselectedLabel: UILabel!
    
    func configure(color: UIColor) {
        graphColorView.backgroundColor = color
        graphColorView.layer.cornerRadius = 10
        graphColorView.layer.borderWidth = 0.5
        graphColorView.layer.borderColor = UIColor.gray.cgColor
        
        if color == .white {
            unselectedLabel.isHidden = false
        } else {
            unselectedLabel.isHidden = true
        }
    }
    
}
