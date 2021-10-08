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
}

final class GoalHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var foldingButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    
    static let height: CGFloat = 50
    weak var delegate: GoalHeaderViewDelegate?
    
    func configure(category: Category) {
        setupTitleLabel(category: category)
        setupFoldingButton(category: category)
        setupAddButton()
        setupDeleteButton()
        separatorView.backgroundColor = .separatorColor
    }
    
    func changeMode(isEdit: Bool) {
        if isEdit {
            addButton.alpha = 1
            deleteButton.alpha = 0
            addButton.isHidden = true
            deleteButton.setFade(.in)
        } else {
            addButton.alpha = 0
            deleteButton.alpha = 1
            addButton.setFade(.in)
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
    
}

// MARK: - setup
private extension GoalHeaderView {
    
    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }
    
    func setupAddButton() {
        addButton.setImage(UIImage(systemName: .plus))
        addButton.isHidden = false
    }
    
    func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: .xmarkCircle))
        deleteButton.isHidden = true
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
    
}
