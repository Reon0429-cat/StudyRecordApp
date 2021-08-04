//
//  StudyRecordGraphColorTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var unselectedLabel: UILabel!
    
    func configure() {
        setupGraphColorView()
    }
    
    private func setupGraphColorView() {
        graphColorView.layer.cornerRadius = 10
        graphColorView.backgroundColor = .white
        graphColorView.layer.borderWidth = 0.5
        graphColorView.layer.borderColor = UIColor.gray.cgColor
    }
    
}
