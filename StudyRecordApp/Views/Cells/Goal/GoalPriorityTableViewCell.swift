//
//  GoalPriorityTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

final class GoalPriorityTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowLabel: UILabel!
    
    private var stackView = UIStackView()
    
    func configure(title: String, priority: Priority) {
        titleLabel.text = title
        setupStackView(priority: priority)
    }
    
    private func setupStackView(priority: Priority) {
        self.stackView.removeFromSuperview()
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        (0...priority.number.rawValue).forEach { _ in
            let imageView = UIImageView()
            imageView.tintColor = .black
            imageView.preferredSymbolConfiguration = .init(pointSize: 20)
            imageView.image = UIImage(systemName: priority.mark.imageName)
            stackView.addArrangedSubview(imageView)
        }
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: arrowLabel.leadingAnchor, constant: -10)
        ])
        self.stackView = stackView
    }
    
}
