//
//  StudyRecordGraphColorTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var unselectedLabel: UILabel!
    @IBOutlet private weak var mandatoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGraphColor()

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setupBorderColor()
        }
    }

    func configure(color: UIColor) {
        graphColorView.backgroundColor = color
        unselectedLabel.isHidden = color.alphaValue != 0
        unselectedLabel.textColor = .dynamicColor(light: .black, dark: .white)
        unselectedLabel.text = L10n.unselected
        mandatoryLabel.text = L10n.mandatory
        titleLabel.text = L10n.graphColor
    }

}

// MARK: - setup
private extension StudyRecordGraphColorTableViewCell {

    func setupGraphColor() {
        graphColorView.layer.cornerRadius = 10
        graphColorView.layer.borderWidth = 0.5
        setupBorderColor()
    }

    func setupBorderColor() {
        graphColorView.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
    }

}
