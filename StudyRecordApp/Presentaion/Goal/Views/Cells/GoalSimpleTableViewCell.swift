//
//  GoalSimpleTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/11.
//

import UIKit

extension GoalSimpleTableViewCell: GoalTableViewCellProtocol {}

final class GoalSimpleTableViewCell: UITableViewCell {

    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var memoTextViewBaseView: UIView!

    weak var delegate: GoalTableViewCellDelegate?
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        selectionStyle = .none
        deleteButton.isHidden = true
        memoTextView.backgroundColor = .dynamicColor(light: .white,
                                                     dark: .secondarySystemGroupedBackground)
        setupBaseView()

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }

    func configure(goal: Category.Goal) {
        setupMemoButton(goal: goal)
        titleLabel.text = goal.title
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
        let titleTriangle = goal.isExpanded ? "▲ " : "▼ "
        memoButton.setTitle(titleTriangle + L10n.memo)
        memoButton.isHidden = goal.memo.isEmpty
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
        memoTextViewBaseView.isHidden = !goal.isExpanded
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
