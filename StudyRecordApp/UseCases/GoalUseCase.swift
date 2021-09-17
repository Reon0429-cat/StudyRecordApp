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
    
    func toggleIsExpanded(at indexPath: IndexPath) {
        let category = repository.read(at: indexPath) 
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
                                   goals: newGoals)
        repository.update(category: newCategory, at: indexPath)
    }
    
}
