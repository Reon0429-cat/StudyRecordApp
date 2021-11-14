//
//  GoalPriorityTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class GoalPriorityTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chevronImageView: UIImageView!

    private var stackView = UIStackView()

    func configure(title: String, priority: Category.Goal.Priority) {
        titleLabel.text = title
        setupStackView(priority: priority)
    }

    private func setupStackView(priority: Category.Goal.Priority) {
        self.stackView.removeFromSuperview()
        let priorityStackView = PriorityStackView(priority: priority)
        self.addSubview(priorityStackView)
        NSLayoutConstraint.activate([
            priorityStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            priorityStackView.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -10)
        ])
        self.stackView = priorityStackView
    }

}
