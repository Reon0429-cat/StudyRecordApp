//
//  StudyRecordGraphColorTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var graphColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        graphColorView.layer.cornerRadius = 10
        
    }
    
}
