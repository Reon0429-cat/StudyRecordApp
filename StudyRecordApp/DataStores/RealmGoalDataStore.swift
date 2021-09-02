//
//  RealmGoalDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import RealmSwift

protocol GoalDataStoreProtocol {
    func create(goal: Goal)
    func read(at index: Int) -> Goal
    func readAll() -> [Goal]
    func update(goal: Goal, at index: Int)
    func delete(at index: Int)
}

final class RealmGoalDataStore: GoalDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<GoalRealm> {
        realm.objects(GoalRealm.self)
    }
    
    func create(goal: Goal) {
        let goalRealm = GoalRealm(goal: goal)
        try! realm.write {
            realm.add(goalRealm)
        }
    }
    
    func read(at index: Int) -> Goal {
        return Goal(goal: objects[index])
    }
    
    func readAll() -> [Goal] {
        return objects.map { Goal(goal: $0) }
    }
    
    func update(goal: Goal, at index: Int) {
        let object = objects[index]
        let goal = Goal(title: goal.title,
                        category: goal.category,
                        memo: goal.memo,
                        priority: goal.priority,
                        dueDate: goal.dueDate,
                        createdDate: goal.createdDate,
                        photoUrlString: goal.photoUrlString)
        try! realm.write {
            object.title = goal.title
            object.category = CategoryRealm(goal: goal)
            object.memo = goal.memo
            object.priority = PriorityRealm(goal: goal)
            object.dueDate = goal.dueDate
            object.createdDate = goal.createdDate
            object.photoUrlString = goal.photoUrlString
        }
    }
    
    func delete(at index: Int) {
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

private extension Goal {
    
    init(goal: GoalRealm) {
        self.title = goal.title
        self.category = Category(goal: goal)
        self.memo = goal.memo
        self.priority = Priority(goal: goal)
        self.dueDate = goal.dueDate
        self.createdDate = goal.createdDate
        self.photoUrlString = goal.photoUrlString
    }
    
}

private extension Category {
    
    init(goal: GoalRealm) {
        let category = Category(title: goal.category?.title ?? "")
        self.title = category.title
    }
    
}

private extension Priority {
    
    init(goal: GoalRealm) {
        let priority = Priority(mark: goal.priority?.mark ?? .star,
                                number: goal.priority?.number ?? .one)
        self.mark = priority.mark
        self.number = priority.number
    }
    
}

private extension GoalRealm {
    
    convenience init(goal: Goal) {
        self.init()
        let goal = Goal(title: goal.title,
                        category: goal.category,
                        memo: goal.memo,
                        priority: goal.priority,
                        dueDate: goal.dueDate,
                        createdDate: goal.createdDate,
                        photoUrlString: goal.photoUrlString)
        self.title = goal.title
        self.category = CategoryRealm(goal: goal)
        self.memo = goal.memo
        self.priority = PriorityRealm(goal: goal)
        self.dueDate = goal.dueDate
        self.createdDate = goal.createdDate
        self.photoUrlString = goal.photoUrlString
    }
    
}

private extension CategoryRealm {
    
    convenience init(goal: Goal) {
        self.init()
        let category = Category(title: goal.category.title)
        self.title = category.title
    }
    
}

private extension PriorityRealm {
    
    convenience init(goal: Goal) {
        self.init()
        let priority = Priority(mark: goal.priority.mark,
                                number: goal.priority.number)
        self.mark = priority.mark
        self.number = priority.number
    }
    
}
