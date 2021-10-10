//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

protocol GoalHeaderViewDelegate: AnyObject {
    func editButtonDidTapped(section: Int)
    func foldingButtonDidTapped(section: Int)
}

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var foldingButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    
    static let height: CGFloat = 70
    weak var delegate: GoalHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupEditButton()
        setupSeparatorView()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }
    
    func configure(category: Category) {
        setupTitleLabel(category: category)
        setupfoldingButton(category: category)
        setColor()
    }
    
}

// MARK: - IBAction func
private extension GoalHeaderView {
    
    @IBAction func editButtonDidTapped(_ sender: Any) {
        delegate?.editButtonDidTapped(section: self.tag)
    }
    
    @IBAction func foldingButtonDidTapped(_ sender: Any) {
        delegate?.foldingButtonDidTapped(section: self.tag)
    }
    
}

// MARK: - setup
private extension GoalHeaderView {
    
    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }
    
    func setupEditButton() {
        
    }
    
    func setupfoldingButton(category: Category) {
        let image: UIImage = {
            if category.isExpanded {
                return UIImage(systemName: .arrowtriangleUpfill)
            }
            return UIImage(systemName: .arrowtriangleDownFill)
        }()
        foldingButton.setImage(image)
    }
    
    func setupSeparatorView() {
        separatorView.backgroundColor = .separatorColor
    }
    
    func setColor() {
    }
    
}

private extension UIView {
    
    func setShadow() {
        self.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                            dark: .accentColor ?? .white),
                       radius: 2,
                       opacity: 0.8,
                       size: (width: 2, height: 2))
    }
    
}
