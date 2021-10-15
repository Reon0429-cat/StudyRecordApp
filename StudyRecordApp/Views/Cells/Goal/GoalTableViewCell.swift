//
//  GoalTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import UIKit

// GoalTableViewCellとGoalSimpleTableViewCellの共通のインターフェース
protocol GoalTableViewCellProtocol where Self: UITableViewCell {
    func configure(goal: Category.Goal)
    func isHidden(_ isHidden: Bool)
    func changeMode(isEdit: Bool, isEvenIndex: Bool)
    var indexPath: IndexPath? { get set }
    var delegate: GoalTableViewCellDelegate? { get set }
}

extension GoalTableViewCellProtocol {
    
    func changeMode(isEdit: Bool,
                    isEvenIndex: Bool,
                    deleteButton: UIButton,
                    baseView: UIView) {
        if isEdit {
            deleteButton.setFade(.in)
            baseView.vibrate(.start, isEvenIndex: isEvenIndex, range: 0.8)
        } else {
            deleteButton.setFade(.out)
            baseView.vibrate(.stop, range: 0.8)
        }
    }
    
}

protocol GoalTableViewCellDelegate: AnyObject {
    func memoButtonDidTapped(indexPath: IndexPath)
    func goalViewDidTapped(indexPath: IndexPath)
    func baseViewLongPressDidRecognized()
    func deleteButtonDidTapped(indexPath: IndexPath)
}

extension GoalTableViewCell: GoalTableViewCellProtocol { }

final class GoalTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var priorityStackViewBaseView: UIView!
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dueDateLabel: UILabel!
    @IBOutlet private weak var createdDateLabel: UILabel!
    @IBOutlet private weak var myImageView: UIImageView!
    @IBOutlet private weak var imageViewBaseView: UIView!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var deleteButton: UIButton!
    
    weak var delegate: GoalTableViewCellDelegate?
    private var priorityStackView = UIStackView()
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        myImageView.layer.cornerRadius = 10
        deleteButton.isHidden = true
        memoTextView.backgroundColor = .dynamicColor(light: .white,
                                                     dark: .secondarySystemGroupedBackground)
        priorityStackViewBaseView.backgroundColor = .clear
        setupBaseView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myImageView.image = nil
        
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
        let createdDateString = Converter.convertToString(from: goal.createdDate)
        let dueDateString = Converter.convertToString(from: goal.dueDate)
        createdDateLabel.text = "\(L10n.createdDate): " + createdDateString
        dueDateLabel.text = "\(L10n.dueDate): " + dueDateString
        myImageView.image = Converter.convertToImage(from: goal.imageData)
        imageViewBaseView.isHidden = (goal.imageData == nil)
        setupMemoTextView(goal: goal)
        setColor()
    }
    
    func changeMode(isEdit: Bool, isEvenIndex: Bool) {
        changeMode(isEdit: isEdit,
                   isEvenIndex: isEvenIndex,
                   deleteButton: deleteButton,
                   baseView: baseView)
    }
    
    func isHidden(_ isHidden: Bool) {
        self.isHidden = isHidden
    }
    
}

// MARK: - IBAction func
private extension GoalTableViewCell {
    
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
private extension GoalTableViewCell {
    
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
        baseView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemGroupedBackground)
        
        let panGR = UITapGestureRecognizer(target: self,
                                           action: #selector(goalViewDidTapped))
        baseView.addGestureRecognizer(panGR)
        let longPressGR = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(goalViewDidLongPressed))
        longPressGR.minimumPressDuration = 1
        baseView.addGestureRecognizer(longPressGR)
    }
    
    @objc
    func goalViewDidTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.goalViewDidTapped(indexPath: indexPath)
    }
    
    @objc
    func goalViewDidLongPressed() {
        delegate?.baseViewLongPressDidRecognized()
    }
    
    func setupMemoTextView(goal: Category.Goal) {
        memoTextView.text = goal.memo
        memoTextView.layer.cornerRadius = 10
        memoTextView.isEditable = false
        memoTextView.clipsToBounds = false
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
