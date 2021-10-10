//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

protocol GoalHeaderViewDelegate: AnyObject {
    func settingButtonDidTapped(convertedSection: Int)
    func foldingButtonDidTapped(convertedSection: Int)
}

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var foldingButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    
    static let height: CGFloat = 70
    weak var delegate: GoalHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSettingButton()
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
    
    @IBAction func settingButtonDidTapped(_ sender: Any) {
        delegate?.settingButtonDidTapped(convertedSection: self.tag)
    }
    
    @IBAction func foldingButtonDidTapped(_ sender: Any) {
        delegate?.foldingButtonDidTapped(convertedSection: self.tag)
    }
    
}

// MARK: - setup
private extension GoalHeaderView {
    
    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }
    
    func setupSettingButton() {
        
    }
    
    func setupfoldingButton(category: Category) {
        let image: UIImage = {
            if category.isExpanded {
                return UIImage(systemName: .arrowtriangleUpfill)
            }
            return UIImage(systemName: .arrowtriangleDownFill)
        }()
        foldingButton.setImage(image)
        foldingButton.isHidden = category.goals.isEmpty
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
