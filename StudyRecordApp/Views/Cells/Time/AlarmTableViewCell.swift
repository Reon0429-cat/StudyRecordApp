//
//  AlarmTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/12.
//

import UIKit

final class AlarmTableViewCell: UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var notifySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction private func switchDidTapped(_ sender: UISwitch) {
        notifySwitch.isOn = sender.isOn
    }
    
    func configure(alarm: Alarm) {
        timeLabel.text = alarm.time
        notifySwitch.isOn = alarm.isOn
    }
    
}
