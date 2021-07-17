//
//  ColorConceptTableViewCell.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/29.
//

import UIKit

final class ColorConceptTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
}
