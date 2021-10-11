//
//  GoalSimpleTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/11.
//

import UIKit

final class GoalSimpleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var priorityStackViewBaseView: UIView!
    
    weak var delegate: GoalTableViewCellDelegate?
    private var priorityStackView = UIStackView()
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        deleteButton.isHidden = true
        baseView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemGroupedBackground)
        memoTextView.backgroundColor = .dynamicColor(light: .white,
                                                     dark: .secondarySystemGroupedBackground)
        priorityStackViewBaseView.backgroundColor = .clear
        setPanGR()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }
    
    func configure(goal: Category.Goal) {
        setupMemoButton(goal: goal)
        setupPriorityStackView(goal: goal)
        titleLabel.text = goal.title
        setupBaseView()
        setupMemoTextView(goal: goal)
        setColor()
    }
    
    func changeMode(isEdit: Bool, isEvenIndex: Bool) {
        if isEdit {
            deleteButton.setFade(.in)
            baseView.vibrate(.start, isEvenIndex: isEvenIndex, range: 0.8)
        } else {
            deleteButton.setFade(.out)
            baseView.vibrate(.stop, range: 0.8)
        }
    }
    
    func isHidden(_ isHidden: Bool) {
        self.isHidden = isHidden
    }
    
}

// MARK: - IBAction func
private extension GoalSimpleTableViewCell {
    
    @IBAction func memoButtonDidTapped(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        delegate?.memoButtonDidTapped(indexPath: indexPath)
    }
    
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        guard let indexPath = indexPath else { return }
        delegate?.deleteButtonDidTapped(indexPath: indexPath)
    }
    
}

// MARK: - setup
private extension GoalSimpleTableViewCell {
    
    func setupMemoButton(goal: Category.Goal) {
        let titleTriangle = goal.isExpanded ?  "▲ " : "▼ "
        memoButton.setTitle(titleTriangle + L10n.memo)
        memoButton.isHidden = goal.memo.isEmpty
    }
    
    func setupPriorityStackView(goal: Category.Goal) {
        self.priorityStackView.removeFromSuperview()
        let priorityStackView = PriorityStackView(priority: goal.priority,
                                                  imageSize: 15)
        baseView.addSubview(priorityStackView)
        NSLayoutConstraint.activate([
            priorityStackView.centerYAnchor.constraint(
                equalTo: priorityStackViewBaseView.centerYAnchor
            ),
            priorityStackView.leadingAnchor.constraint(
                equalTo: priorityStackViewBaseView.leadingAnchor
            )
        ])
        self.priorityStackView = priorityStackView
    }
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 10
    }
    
    func setupMemoTextView(goal: Category.Goal) {
        memoTextView.text = goal.memo
        memoTextView.layer.cornerRadius = 10
        memoTextView.isEditable = false
        memoTextView.clipsToBounds = false
    }
    
    func setPanGR() {
        let panGR = UITapGestureRecognizer(target: self,
                                           action: #selector(goalViewDidTapped))
        panGR.delegate = self
        baseView.addGestureRecognizer(panGR)
    }
    
    @objc
    func goalViewDidTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.goalViewDidTapped(indexPath: indexPath)
    }
    
    func setColor() {
        baseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                dark: .accentColor ?? .white),
                           radius: 3,
                           opacity: 0.8,
                           size: (width: 2, height: 2))
        memoTextView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                    dark: .accentColor ?? .white),
                               radius: 3,
                               opacity: 0.8,
                               size: (width: 2, height: 2))
        let image = UIImage(systemName: .xmarkCircleFill)
        let color: UIColor = .dynamicColor(light: .mainColor ?? .black,
                                           dark: .mainColor ?? .white)
        deleteButton.setImage(image.setColor(color))
    }
    
}
