//
//  RealmGoalDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import RealmSwift

protocol GoalDataStoreProtocol {
    func create(category: CategoryRealm)
    func readAll() -> [CategoryRealm]
    func update(category: CategoryRealm)
    func delete(category: CategoryRealm)
}

final class RealmGoalDataStore: GoalDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<CategoryRealm> {
        realm.objects(CategoryRealm.self)
    }
    
    func create(category: CategoryRealm) {
        try! realm.write {
            realm.add(category)
        }
    }
    
    func readAll() -> [CategoryRealm] {
        return objects.map { $0 }
    }
    
    func update(category: CategoryRealm) {
        let object = realm.object(ofType: CategoryRealm.self,
                                  forPrimaryKey: category.identifier) ?? CategoryRealm()
        try! realm.write {
            object.title = category.title
            object.isExpanded = category.isExpanded
            object.goals = category.goals
        }
    }
    
    func delete(category: CategoryRealm) {
        let object = realm.object(ofType: CategoryRealm.self,
                                  forPrimaryKey: category.identifier) ?? CategoryRealm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
}
