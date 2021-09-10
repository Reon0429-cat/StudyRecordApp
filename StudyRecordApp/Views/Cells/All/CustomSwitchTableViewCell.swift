//
//  CustomSwitchTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/10.
//

import UIKit

final class CustomSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var customSwitch: CustomSwitch!
    
    var switchDidSelected: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
    }
    
    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        customSwitch.isOn = isOn
    }
    
    @IBAction private func customSwitchDidSelected(_ sender: UISwitch) {
        switchDidSelected?(sender.isOn)
    }
    
}
