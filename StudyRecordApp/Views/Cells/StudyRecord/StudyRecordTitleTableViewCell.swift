//
//  StudyRecordTitleTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    var onTapEvent: (() -> Void)?
    
    func configure(onTapEvent: @escaping () -> Void) {
        self.onTapEvent = onTapEvent
    }
    
}
