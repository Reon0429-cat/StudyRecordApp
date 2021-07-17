//
//  SectionHeaderView.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

final class SectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var view: UIView!
    
    var onTapEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(didTapped))
        self.view.addGestureRecognizer(tapGR)
        
    }
    
    @objc private func didTapped() {
        onTapEvent?()
    }
    
    func configure(title: String,
                   onTapEvent: @escaping () -> Void) {
        self.onTapEvent = onTapEvent
        titleLabel.text = title
    }
    
    
}
