//
//  AccordionColorTableViewCell.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/11.
//

import UIKit

protocol AccordionColorTableViewCellDelegate: AnyObject {
    func tileViewDidTapped(selectedView: TileView, isLast: Bool, index: Int)
    func titleViewDidTapped(index: Int)
}

final class AccordionColorTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleBaseView: UIView!
    @IBOutlet private weak var stackView: UIStackView!

    weak var delegate: AccordionColorTableViewCellDelegate?
    private var selectingCount = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        setupStackView()
        setupTapGR()
        selectionStyle = .none

    }

    func configure(title: String, colors: [UIColor]) {
        selectingCount = 0
        titleLabel.text = title
        stackView.arrangedSubviews
            .map { $0 as! TileView }
            .enumerated()
            .forEach { index, tileView in
                tileView.change(state: .square)
                tileView.change(color: colors[index])
            }
    }

}

// MARK: - TileViewDelegate
extension AccordionColorTableViewCell: TileViewDelegate {

    func tileViewDidTapped(selectedView: TileView) {
        if selectedView.getState() == .square {
            selectingCount += 1
        }
        let isLast = (selectingCount == stackView.arrangedSubviews.count)
        delegate?.tileViewDidTapped(selectedView: selectedView,
                                    isLast: isLast,
                                    index: self.tag)
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
