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
        let newCategory = Category(title: category.title,
                                   isExpanded: category.isExpanded,
                                   goals: newGoals,
                                   identifier: category.identifier)
        repository.update(category: newCategory)
    }
    
    func update(category: Category) {
        repository.update(category: category)
    }
    
    func update(goal: Category.Goal, at indexPath: IndexPath) {
        let category = repository.read(at: indexPath.section)
        var goals = category.goals
        goals[indexPath.row] = goal
        let newCategory = Category(title: category.title,
                                   isExpanded: category.isExpanded,
                                   goals: goals,
                                   identifier: category.identifier)
        repository.update(category: newCategory)
    }
    
    func toggleGoalIsExpanded(at indexPath: IndexPath) {
        let category = repository.read(at: indexPath.section)
        let goal = category.goals[indexPath.row]
        let newGoal = Category.Goal(title: goal.title,
                                    memo: goal.memo,
                                    isExpanded: !goal.isExpanded,
                                    priority: goal.priority,
                                    dueDate: goal.dueDate,
                                    createdDate: goal.createdDate,
                                    imageData: goal.imageData)
        var newGoals = category.goals
        newGoals[indexPath.row] = newGoal
        let newCategory = Category(title: category.title,
                                   isExpanded: category.isExpanded,
                                   goals: newGoals,
                                   identifier: category.identifier)
        repository.update(category: newCategory)
    }
    
    func toggleCategoryIsExpanded(at section: Int) {
        let category = repository.readAll()[section]
        let newCategory = Category(title: category.title,
                                   isExpanded: !category.isExpanded,
                                   goals: category.goals,
                                   identifier: category.identifier)
        repository.update(category: newCategory)
    }
    
}
