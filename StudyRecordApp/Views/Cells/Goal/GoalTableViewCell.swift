//
//  GoalTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImageView.layer.cornerRadius = 10
        
    }
    
    func configure(title: String, image: UIImage?) {
        titleLabel.text = title
        myImageView.image = image
    }
    
}
