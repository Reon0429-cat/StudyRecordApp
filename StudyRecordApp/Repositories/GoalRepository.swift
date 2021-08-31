//
//  GoalRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/31.
//

import Foundation

protocol GoalRepositoryProtocol {
    func create(goal: Goal)
    func read(at index: Int) -> Goal
    func readAll() -> [Goal]
    func update(goal: Goal, at index: Int)
    func delete(at index: Int)
}

final class GoalRepository: GoalRepositoryProtocol { 
    
    private var dataStore: GoalDataStoreProtocol
    init(dataStore: GoalDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(goal: Goal) {
        dataStore.create(goal: goal)
    }
    
    func read(at index: Int) -> Goal {
        return dataStore.read(at: index)
    }
    
    func readAll() -> [Goal] {
        return dataStore.readAll()
    }
    
    func update(goal: Goal, at index: Int) {
        dataStore.update(goal: goal, at: index)
    }
    
    func delete(at index: Int) {
        dataStore.delete(at: index)
    }
    
}
