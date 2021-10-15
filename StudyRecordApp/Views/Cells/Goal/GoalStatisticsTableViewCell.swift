//
//  GoalStatisticsTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/16.
//

import UIKit

final class GoalStatisticsTableViewCell: UITableViewCell {

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var achievementLabel: UILabel!
    @IBOutlet private weak var unarchievementLabel: UILabel!
    @IBOutlet private weak var achievementScoreLabel: UILabel!
    @IBOutlet private weak var unarchievementScoreLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var oneStarPriorityCountLabel: UILabel!
    @IBOutlet private weak var twoStarPriorityCountLabel: UILabel!
    @IBOutlet private weak var threeStarPriorityCountLabel: UILabel!
    @IBOutlet private weak var fourStarPriorityCountLabel: UILabel!
    @IBOutlet private weak var fiveStarPriorityCountLabel: UILabel!
    @IBOutlet private weak var oneHeartPriorityCountLabel: UILabel!
    @IBOutlet private weak var twoHeartPriorityCountLabel: UILabel!
    @IBOutlet private weak var threeHeartPriorityCountLabel: UILabel!
    @IBOutlet private weak var fourHeartPriorityCountLabel: UILabel!
    @IBOutlet private weak var fiveHeartPriorityCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        achievementLabel.text = L10n.achieved
        unarchievementLabel.text = L10n.unarchived
        priorityLabel.text = L10n.priority
        
    }
    
    func configure(category: Category) {
        setupCategoryNameLabel(category: category)
        setupAchievementScoreLabel(category: category)
        setupUnarchivementScoreLabel(category: category)
        setupStarPriorityLabel(category: category)
        setupHeartPriorityLabel(category: category)
    }
    
}

// MARK: - setup
private extension GoalStatisticsTableViewCell {
    
    func setupCategoryNameLabel(category: Category) {
        categoryNameLabel.text = category.title
    }
    
    func setupAchievementScoreLabel(category: Category) {
        let achievedCount = category.goals.filter { $0.isChecked }.count
        let achievedCountAsPercentage = Int(Double(achievedCount) / Double(category.goals.count) * 100)
        achievementScoreLabel.text = "\(achievedCount) (\(achievedCountAsPercentage)%)"
    }
    
    func setupUnarchivementScoreLabel(category: Category) {
        let unarchievedCount = category.goals.filter { !$0.isChecked }.count
        let unarchievedCountAsPercentage = Int(Double(unarchievedCount) / Double(category.goals.count) * 100)
        unarchievementScoreLabel.text = "\(unarchievedCount) (\(unarchievedCountAsPercentage)%)"
    }
    
    func setupStarPriorityLabel(category: Category) {
        let starGoals = category.goals.filter { $0.priority.mark == .star }
        oneStarPriorityCountLabel.text = "\(starGoals.filter { $0.priority.number == .one }.count)"
        twoStarPriorityCountLabel.text = "\(starGoals.filter { $0.priority.number == .two }.count)"
        threeStarPriorityCountLabel.text = "\(starGoals.filter { $0.priority.number == .three }.count)"
        fourStarPriorityCountLabel.text = "\(starGoals.filter { $0.priority.number == .four }.count)"
        fiveStarPriorityCountLabel.text = "\(starGoals.filter { $0.priority.number == .five }.count)"
    }
    
    func setupHeartPriorityLabel(category: Category) {
        let heartGoals = category.goals.filter { $0.priority.mark == .heart }
        oneHeartPriorityCountLabel.text = "\(heartGoals.filter { $0.priority.number == .one }.count)"
        twoHeartPriorityCountLabel.text = "\(heartGoals.filter { $0.priority.number == .two }.count)"
        threeHeartPriorityCountLabel.text = "\(heartGoals.filter { $0.priority.number == .three }.count)"
        fourHeartPriorityCountLabel.text = "\(heartGoals.filter { $0.priority.number == .four }.count)"
        fiveHeartPriorityCountLabel.text = "\(heartGoals.filter { $0.priority.number == .five }.count)"
    }

}
