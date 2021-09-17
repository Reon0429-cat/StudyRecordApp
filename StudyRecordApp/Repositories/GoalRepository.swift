//
//  GoalRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

protocol GoalRepositoryProtocol {
    func create(category: Category)
    func read(at indexPath: IndexPath) -> Category
    func readAll() -> [Category]
    func update(category: Category, at indexPath: IndexPath)
    func delete(at indexPath: IndexPath)
}

final class GoalRepository: GoalRepositoryProtocol {
    
    private var dataStore: GoalDataStoreProtocol
    init(dataStore: GoalDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(category: Category) {
        dataStore.create(category: category)
    }
    
    func read(at indexPath: IndexPath) -> Category {
        return dataStore.read(at: indexPath)
    }
    
    func readAll() -> [Category] {
        return dataStore.readAll()
    }
    
    func update(category: Category, at indexPath: IndexPath) {
        dataStore.update(category: category, at: indexPath)
    }
    
    func delete(at indexPath: IndexPath) {
        dataStore.delete(at: indexPath)
    }
    
}
