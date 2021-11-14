//
//  CustomButtonTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/10.
//

import UIKit

final class SettingLogoutCustomButtonTableViewCell: UITableViewCell {

    @IBOutlet private weak var button: UIButton!

    var onTapEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

    }

    func configure(title: String) {
        button.setTitle(title)
    }

    @IBAction private func buttonDidTapped(_ sender: Any) {
        onTapEvent?()
    }

}
