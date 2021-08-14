//
//  StudyRecordTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class StudyRecordTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.layer.cornerRadius = 10
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        backgroundColor = .clear
        
    }
    
    func configure(record: Record) {
        textView.text = record.memo
    }
    
}
