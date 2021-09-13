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
        // MARK: - ToDo ローカライズ対応する
        dateLabel.text = "\(history.year)年\(history.month)月\(history.day)日"
        let minuteText = LocalizeKey.minute.localizedString()
        let hourText = LocalizeKey.hour.localizedString()
        switch (history.hour == 0, history.minutes == 0) {
            case (true, true):
                timeLabel.text = "0 " + minuteText
            case (false, true):
                timeLabel.text = "\(history.hour) " + hourText
            case (false, false):
                timeLabel.text = "\(history.hour) " + hourText + " \(history.minutes) " + minuteText
            case (true, false):
                timeLabel.text = "\(history.minutes) " + minuteText
        }
    }
    
}
