//
//  GoalRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

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
        dataStore.create(category: category)
    }
    
    func read(at index: Int) -> Category {
        return dataStore.readAll()[index]
    }
    
    func readAll() -> [Category] {
        return dataStore.readAll()
    }
    
    func update(category: Category) {
        dataStore.update(category: category)
    }
    
    func delete(category: Category) {
        dataStore.delete(category: category)
    }
    
}
