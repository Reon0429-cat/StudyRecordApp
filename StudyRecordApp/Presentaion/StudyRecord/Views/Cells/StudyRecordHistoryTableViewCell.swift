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
        let date = Date().fixed(year: history.year,
                                month: history.month,
                                day: history.day)
        let dateString = Converter.convertToString(from: date)
        dateLabel.text = dateString
        let minuteText = L10n.shortMinute
        let hourText = L10n.shortHour
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
