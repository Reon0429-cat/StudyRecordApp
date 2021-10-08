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
    
}
