//
//  GoalRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation
import RealmSwift

protocol GoalRepositoryProtocol {
    func create(category: Category)
    func read(at index: Int) -> Category
    func readAll() -> [Category]
    func update(category: Category)
    func delete(category: Category)
}

final class GoalRepository: GoalRepositoryProtocol {
    
    private var dataStore: GoalDataStoreProtocol
    init(dataStore: GoalDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(category: Category) {
        let categoryRealm = CategoryRealm(category: category)
        dataStore.create(category: categoryRealm)
    }
    
    func read(at index: Int) -> Category {
        let category = Category(category: dataStore.readAll()[index])
        return category
    }
    
    func readAll() -> [Category] {
        let categories = dataStore.readAll().map { Category(category: $0) }
        return categories
    }
    
    func update(category: Category) {
        let categoryRealm = CategoryRealm(category: category)
        dataStore.update(category: categoryRealm)
    }
    
    func delete(category: Category) {
        let categoryRealm = CategoryRealm(category: category)
        dataStore.delete(category: categoryRealm)
    }
    
}


private extension Category {
    
    init(category: CategoryRealm) {
        self.title = category.title
        self.isExpanded = category.isExpanded
        self.goals = category.commonGoals
        self.identifier = category.identifier
    }
    
}

private extension CategoryRealm {
    
    convenience init(category: Category) {
        self.init()
        let category = Category(title: category.title,
                                isExpanded: category.isExpanded,
                                goals: category.goals,
                                identifier: category.identifier)
        self.title = category.title
        self.isExpanded = category.isExpanded
        self.goals = category.realmGoals
        self.identifier = category.identifier
    }
    
}

private extension Category {
    
    var realmGoals: List<GoalRealm> {
        let goals = List<GoalRealm>()
        self.goals.forEach { goal in
            let goalRealm = GoalRealm(goal: goal)
            goals.append(goalRealm)
        }
        return goals
    }
    
}

private extension Category.Goal {
    
    init(goal: GoalRealm) {
        self.init(title: goal.title,
                  memo: goal.memo,
                  isExpanded: goal.isExpanded,
                  priority: goal.priority?.toCommon
                  ?? Priority(mark: .star, number: .one),
                  dueDate: goal.dueDate,
                  createdDate: goal.createdDate,
                  imageData: goal.imageData)
    }
    
}

private extension PriorityRealm {
    
    var toCommon: Category.Goal.Priority {
        let priority = Category.Goal.Priority(mark: self.mark,
                                              number: self.number)
        return priority
    }
    
}

private extension CategoryRealm {
    
    var commonGoals: [Category.Goal] {
        var goals = [Category.Goal]()
        self.goals.forEach { goal in
            let goal = Category.Goal(goal: goal)
            goals.append(goal)
        }
        return goals
    }
    
}

private extension GoalRealm {
    
    convenience init(goal: Category.Goal) {
        self.init()
        let goal = Category.Goal(title: goal.title,
                                 memo: goal.memo,
                                 isExpanded: goal.isExpanded,
                                 priority: goal.priority,
                                 dueDate: goal.dueDate,
                                 createdDate: goal.createdDate,
                                 imageData: goal.imageData)
        self.title = goal.title
        self.memo = goal.memo
        self.isExpanded = goal.isExpanded
        self.priority = goal.realmPriority
        self.dueDate = goal.dueDate
        self.createdDate = goal.createdDate
        self.imageData = goal.imageData
    }
    
}

private extension Category.Goal {
    
    var realmPriority: PriorityRealm {
        let priorityRealm = PriorityRealm(priority: self.priority)
        return priorityRealm
    }
    
}

private extension PriorityRealm {
    
    convenience init(priority: Category.Goal.Priority) {
        self.init()
        let priority = Category.Goal.Priority(mark: priority.mark,
                                              number: priority.number)
        self.mark = priority.mark
        self.number = priority.number
    }
    
}

