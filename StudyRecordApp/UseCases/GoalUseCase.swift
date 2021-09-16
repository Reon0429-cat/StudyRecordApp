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
    
    var goals: [Goal] {
        repository.readAll()
    }
    
    func create(goal: Goal) {
        repository.create(goal: goal)
    }
    
    func toggleIsExpanded(at index: Int) {
        let goal = repository.read(at: index)
        let newGoal = Goal(title: goal.title,
                           category: goal.category,
                           memo: goal.memo,
                           isExpanded: !goal.isExpanded,
                           priority: goal.priority,
                           dueDate: goal.dueDate,
                           createdDate: goal.createdDate,
                           imageData: goal.imageData)
        repository.update(goal: newGoal, at: index)
    }
    
}
