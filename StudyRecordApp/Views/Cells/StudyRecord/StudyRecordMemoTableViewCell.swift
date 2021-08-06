//
//  StudyRecordMemoTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordMemoTableViewCell: UITableViewCell {

    @IBOutlet private weak var inputtedMemoLabel: UILabel!
    
    func configure(memo: String) {
        inputtedMemoLabel.text = memo
    }
    
}
