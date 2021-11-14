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
    func deleteAllCategory()
    func deleteGoal(indexPath: IndexPath)
    func sortCategory(from sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath)
    func sortGoal(from sourceIndexPath: IndexPath,
                  to destinationIndexPath: IndexPath)
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

    func deleteAllCategory() {
        dataStore.deleteAllCategory()
    }

    func deleteGoal(indexPath: IndexPath) {
        let categoryRealm = dataStore.readAll()[indexPath.section]
        dataStore.deleteGoal(category: categoryRealm,
                             indexPath: indexPath)
    }

    func sortCategory(from sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath) {
        let sourceCategory = dataStore.readAll()[sourceIndexPath.row]
        let destinationCategory = dataStore.readAll()[destinationIndexPath.row]
        dataStore.sortCategory(from: sourceCategory,
                               to: destinationCategory)
    }

    func sortGoal(from sourceIndexPath: IndexPath,
                  to destinationIndexPath: IndexPath) {
        let sourceGoal = getGoal(indexPath: sourceIndexPath)
        let destinationGoal = getGoal(indexPath: destinationIndexPath)
        let categoryRealm = dataStore.readAll()[sourceIndexPath.section]
        dataStore.sortGoal(category: categoryRealm,
                           from: sourceGoal,
                           to: destinationGoal)
    }

    private func getGoal(indexPath: IndexPath) -> GoalRealm {
        let category = dataStore.readAll()[indexPath.section]
        let goal = category.goals[indexPath.row]
        return goal
    }

}

private extension Category {

    init(category: CategoryRealm) {
        self = Category(title: category.title,
                        isExpanded: category.isExpanded,
                        goals: category.commonGoals,
                        isAchieved: category.isAchieved,
                        order: category.order,
                        identifier: category.identifier)
    }

}

private extension CategoryRealm {

    convenience init(category: Category) {
        self.init()
        let category = Category(title: category.title,
                                isExpanded: category.isExpanded,
                                goals: category.goals,
                                isAchieved: category.isAchieved,
                                order: category.order,
                                identifier: category.identifier)
        self.title = category.title
        self.isExpanded = category.isExpanded
        self.goals = category.realmGoals
        self.isAchieved = category.isAchieved
        self.order = category.order
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
                  isChecked: goal.isChecked,
                  dueDate: goal.dueDate,
                  createdDate: goal.createdDate,
                  imageData: goal.imageData,
                  order: goal.order,
                  identifier: goal.identifier)
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
                                 isChecked: goal.isChecked,
                                 dueDate: goal.dueDate,
                                 createdDate: goal.createdDate,
                                 imageData: goal.imageData,
                                 order: goal.order,
                                 identifier: goal.identifier)
        self.title = goal.title
        self.memo = goal.memo
        self.isExpanded = goal.isExpanded
        self.priority = goal.realmPriority
        self.isChecked = goal.isChecked
        self.dueDate = goal.dueDate
        self.createdDate = goal.createdDate
        self.imageData = goal.imageData
        self.order = goal.order
        self.identifier = goal.identifier
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
