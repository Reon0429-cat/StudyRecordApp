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
    
    func configure(date: String, hour: Int, minutes: Int) {
        dateLabel.text = date
        switch (hour == 0, minutes == 0) {
            case (true, true):
                timeLabel.text = "0分"
            case (false, true):
                timeLabel.text = "\(hour)時間"
            case (false, false):
                timeLabel.text = "\(hour)時間\(minutes)分"
            case (true, false):
                timeLabel.text = "\(minutes)分"
        }
    }
    
}
