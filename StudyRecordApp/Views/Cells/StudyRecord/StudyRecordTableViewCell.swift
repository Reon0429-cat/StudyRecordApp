//
//  StudyRecordTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

final class StudyRecordTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    var didChangedText: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        textView.layer.cornerRadius = 10
        
    }
    
    func configure(record: Record) {
        textView.text = record.memo
    }
    
}

extension StudyRecordTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        didChangedText?()
    }
}