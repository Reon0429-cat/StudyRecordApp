//
//  AccordionColorTableViewCell.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/11.
//

import UIKit

protocol AccordionColorTableViewCellDelegate: AnyObject {
    func tileViewDidTapped(selectedView: UIView)
    func titleViewDidTapped(index: Int)
}

final class AccordionColorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleBaseView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    
    weak var delegate: AccordionColorTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stackView.arrangedSubviews.forEach { $0.layer.cornerRadius = 0 }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStackView()
        setupTapGR()
        selectionStyle = .none
        
    }
    
    func configure(title: String, colors: [UIColor]) {
        titleLabel.text = title
        stackView.arrangedSubviews.enumerated()
            .forEach { index, view in
                view.backgroundColor = colors[index]
            }
    }
    
}

// MARK: - TileViewDelegate
extension AccordionColorTableViewCell: TileViewDelegate {
    
    func tileViewDidTapped(selectedView: UIView) {
        delegate?.tileViewDidTapped(selectedView: selectedView)
    }
    
}

// MARK: - setup
private extension AccordionColorTableViewCell {
    
    func setupStackView() {
        stackView.arrangedSubviews
            .map { $0 as! TileView }
            .forEach { $0.delegate = self }
    }
    
    func setupTapGR() {
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(tapGRAction))
        titleBaseView.addGestureRecognizer(tapGR)
    }
    
    @objc
    func tapGRAction() {
        delegate?.titleViewDidTapped(index: self.tag)
    }
    
}
