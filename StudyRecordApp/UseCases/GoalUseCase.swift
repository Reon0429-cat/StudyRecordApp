//
//  GoalUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

final class GoalUseCase {
    
    private let repository: GoalRepositoryProtocol
    init(repository: GoalRepositoryProtocol) {
        self.repository = repository
    }
    
    var categories: [Category] {
        return repository.readAll()
    }
    
    func save(category: Category) {
        repository.create(category: category)
    }
    
    func save(goal: Category.Goal, section: Int) {
        let category = repository.read(at: section)
        let newGoals = category.goals + [goal]
        let newCategory = Category(category: category,
                                   goals: newGoals)
        repository.update(category: newCategory)
    }
    
    func update(category: Category) {
        repository.update(category: category)
    }
    
    func update(goal: Category.Goal, at indexPath: IndexPath) {
        let category = repository.read(at: indexPath.section)
        var goals = category.goals
        goals[indexPath.row] = goal
        let newCategory = Category(category: category,
                                   goals: goals)
        repository.update(category: newCategory)
    }
    
    func toggleGoalIsExpanded(at indexPath: IndexPath) {
        let category = repository.read(at: indexPath.section)
        let goal = category.goals[indexPath.row]
        let newGoal = Category.Goal(goal: goal,
                                    isExpanded: !goal.isExpanded)
        var newGoals = category.goals
        newGoals[indexPath.row] = newGoal
        let newCategory = Category(category: category,
                                   goals: newGoals)
        repository.update(category: newCategory)
    }
    
    func toggleCategoryIsExpanded(at section: Int) {
        let category = repository.readAll()[section]
        let newCategory = Category(category: category,
                                   isExpanded: !category.isExpanded)
        repository.update(category: newCategory)
    }
    
    func deleteAllCategory() {
        repository.deleteAllCategory()
    }
    
    func deleteGoal(at indexPath: IndexPath) {
        repository.deleteGoal(indexPath: indexPath)
    }
    
    func deleteCategory(at section: Int) {
        let category = repository.readAll()[section]
        repository.delete(category: category)
    }
    
    func sortCategory(from sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath) {
        repository.sortCategory(from: sourceIndexPath,
                                to: destinationIndexPath)
    }
    
    func sortGoal(tappedSection: Int,
                  from sourceIndex: Int,
                  to destinationIndex: Int) {
        let sourceIndexPath = IndexPath(row: sourceIndex,
                                        section: tappedSection)
        let destinationIndexPath = IndexPath(row: destinationIndex,
                                             section: tappedSection)
        repository.sortGoal(from: sourceIndexPath,
                            to: destinationIndexPath)
    }
    
    func toggleIsAchieved(at section: Int) {
        let category = repository.readAll()[section]
        let newCategory = Category(category: category,
                                   isAchieved: !category.isAchieved)
        repository.update(category: newCategory)
    }
    
}
