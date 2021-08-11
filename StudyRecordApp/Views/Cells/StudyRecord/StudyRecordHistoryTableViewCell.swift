//
//  StudyRecordHistoryTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/07.
//

import UIKit

final class StudyRecordHistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    func configure(history: History) {
        dateLabel.text = "\(history.year)年\(history.month)月\(history.day)日"
        switch (history.hour == 0, history.minutes == 0) {
            case (true, true):
                timeLabel.text = "0分"
            case (false, true):
                timeLabel.text = "\(history.hour)時間"
            case (false, false):
                timeLabel.text = "\(history.hour)時間\(history.minutes)分"
            case (true, false):
                timeLabel.text = "\(history.minutes)分"
        }
    }
    
}
