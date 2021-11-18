//
//  GoalHeaderView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/17.
//

import UIKit

protocol GoalHeaderViewDelegate: AnyObject {
    func foldingButtonDidTapped(convertedSection: Int)
    func addButtonDidTapped(convertedSection: Int)
    func editButtonDidTapped(convertedSection: Int)
    func sortButtonDidTapped(convertedSection: Int)
    func achieveButtonDidTapped(convertedSection: Int)
    func deleteButtonDidTapped(convertedSection: Int)
}

final class GoalHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var foldingButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!

    static let estimatedHeight: CGFloat = 50
    weak var delegate: GoalHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSeparatorView()

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }

    func configure(category: Category, isAchieved: Bool) {
        setupTitleLabel(category: category)
        setupfoldingButton(category: category)
        setupSettingButton(isAchieved: isAchieved)
        setColor()
    }

    private func createUIMenu(isAchieved: Bool) -> UIMenu {
        let addAction = UIAction(title: L10n.add,
                                 image: UIImage(systemName: .plus)) { _ in
            self.delegate?.addButtonDidTapped(convertedSection: self.tag)
        }
        let editAction = UIAction(title: L10n.edit,
                                  image: UIImage(systemName: .pencil)) { _ in
            self.delegate?.editButtonDidTapped(convertedSection: self.tag)
        }
        let sortAction = UIAction(title: L10n.sort,
                                  image: UIImage(systemName: .arrowUpArrowDown)) { _ in
            self.delegate?.sortButtonDidTapped(convertedSection: self.tag)
        }
        let achieveTitle = isAchieved ? L10n.unarchive : L10n.achieve
        let achieveSystemName: SystemName = isAchieved ? .flagSlash : .flag
        let achieveAction = UIAction(title: achieveTitle,
                                     image: UIImage(systemName: achieveSystemName)) { _ in
            self.delegate?.achieveButtonDidTapped(convertedSection: self.tag)
        }
        let deleteAction = UIAction(title: L10n.delete,
                                    image: UIImage(systemName: .trash),
                                    attributes: .destructive) { _ in
            self.delegate?.deleteButtonDidTapped(convertedSection: self.tag)
        }
        let actions = [addAction, editAction, sortAction, achieveAction, deleteAction]
        return UIMenu(title: "",
                      options: .displayInline,
                      children: actions)
    }

}

// MARK: - IBAction func
private extension GoalHeaderView {

    @IBAction func settingButtonDidTapped(_ sender: Any) {}

    @IBAction func foldingButtonDidTapped(_ sender: Any) {
        delegate?.foldingButtonDidTapped(convertedSection: self.tag)
    }

}

// MARK: - setup
private extension GoalHeaderView {

    func setupTitleLabel(category: Category) {
        titleLabel.text = category.title + " (\(category.goals.count))"
    }

    func setupSettingButton(isAchieved: Bool) {
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = createUIMenu(isAchieved: isAchieved)
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

    func setColor() {}

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
