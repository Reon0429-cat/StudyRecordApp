//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

protocol GoalHeaderViewDelegate: AnyObject {
    func addButtonDidTapped(section: Int)
    func deleteButtonDidTapped(section: Int)
    func foldingButtonDidTapped(section: Int)
    func sortButtonDidTapped(section: Int)
}

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var foldingButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var sortButton: UIButton!
    
    static let height: CGFloat = 50
    weak var delegate: GoalHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAddButton()
        setupDeleteButton()
        setupSortButton()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }
    
    func configure(category: Category) {
        setupTitleLabel(category: category)
        setupFoldingButton(category: category)
        setColor()
    }
    
    func changeMode(isEdit: Bool) {
        if isEdit {
            addButton.isHidden = true
            if sortButton.isHidden {
                sortButton.setFade(.in)
            }
            deleteButton.isHidden = false
        } else {
            addButton.isHidden = false
            if !sortButton.isHidden {
                sortButton.setFade(.out)
            }
            deleteButton.isHidden = true
        }
    }
    
}

// MARK: - IBAction func
private extension GoalHeaderView {
    
    @IBAction func addButtonDidTapped(_ sender: Any) {
        delegate?.addButtonDidTapped(section: self.tag)
    }
    
    @IBAction func foldingButtonDidTapped(_ sender: Any) {
        delegate?.foldingButtonDidTapped(section: self.tag)
    }
    
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        delegate?.deleteButtonDidTapped(section: self.tag)
    }
    
    @IBAction func sortButtonDidTapped(_ sender: Any) {
        delegate?.sortButtonDidTapped(section: self.tag)
    }
    
}

// MARK: - setup
private extension GoalHeaderView {
    
    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }
    
    func setupAddButton() {
        addButton.setImage(UIImage(systemName: .plusCircle))
        addButton.isHidden = false
    }
    
    func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: .xmarkCircle))
        deleteButton.isHidden = true
    }
    
    func setupSortButton() {
        sortButton.setImage(UIImage(systemName: .arrowUpArrowDownCircleFill))
        sortButton.isHidden = true
    }
    
    func setupFoldingButton(category: Category) {
        foldingButton.isHidden = category.goals.isEmpty
        let image: UIImage = {
            if category.isExpanded {
                return UIImage(systemName: .arrowtriangleUpfill)
            }
            return UIImage(systemName: .arrowtriangleDownFill)
        }()
        foldingButton.setImage(image)
    }
    
    func setColor() {
        addButton.setShadow()
        foldingButton.setShadow()
        deleteButton.setShadow()
        sortButton.setShadow()
    }
    
}

private extension UIView {
    
    func setShadow() {
        self.setShadow(color: .dynamicColor(light: .mainColor ?? .black,
                                            dark: .mainColor ?? .white),
                       radius: 1,
                       opacity: 0.8,
                       size: (width: 2, height: 2))
    }
    
}
