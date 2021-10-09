//
//  RealmGoalDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

protocol GoalDataStoreProtocol {
    func create(category: CategoryRealm)
    func readAll() -> [CategoryRealm]
    func update(category: CategoryRealm)
    func delete(category: CategoryRealm)
    func deleteGoal(category: CategoryRealm,
                    indexPath: IndexPath)
    func sortCategory(from sourceCategory: CategoryRealm,
                      to destinationCategory: CategoryRealm)
    func sortGoal(category: CategoryRealm,
                  from sourceGoal: GoalRealm,
                  to destinationGoal: GoalRealm)
}

final class RealmGoalDataStore: GoalDataStoreProtocol {
    
    func create(category: CategoryRealm) {
        RealmManager().create(object: category)
    }
    
    func readAll() -> [CategoryRealm] {
        return RealmManager().readAll(type: CategoryRealm.self)
    }
    
    func update(category: CategoryRealm) {
        RealmManager().update(object: category)
    }
    
    func delete(category: CategoryRealm) {
        RealmManager().delete(object: category)
    }
    
    func deleteGoal(category: CategoryRealm,
                    indexPath: IndexPath) {
        RealmManager().ex.deleteList(objects: category.goals,
                                     at: indexPath.row)
    }
    
    func sortCategory(from sourceCategory: CategoryRealm,
                      to destinationCategory: CategoryRealm) {
        RealmManager().sort(sourceObject: sourceCategory,
                            destinationObject: destinationCategory)
    }
    
    func sortGoal(category: CategoryRealm,
                  from sourceGoal: GoalRealm,
                  to destinationGoal: GoalRealm) {
        RealmManager().ex.sortList(objects: category.goals,
                                   sourceObject: sourceGoal,
                                   destinationObject: destinationGoal)
    }
    
}
