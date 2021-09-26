//
//  SettingRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import Foundation

protocol SettingRepositoryProtocol {
    func create(setting: Setting)
    func read(at index: Int) -> Setting
    func readAll() -> [Setting]
    func update(setting: Setting)
    func delete(setting: Setting)
}

final class SettingRepository: SettingRepositoryProtocol {
    
    private var dataStore: SettingDataStoreProtocol
    init(dataStore: SettingDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func create(setting: Setting) {
        dataStore.create(setting: setting)
    }
    
    func read(at index: Int) -> Setting {
        return dataStore.readAll()[index]
    }
    
    func readAll() -> [Setting] {
        return dataStore.readAll()
    }
    
    func update(setting: Setting) {
        dataStore.update(setting: setting)
    }
    
    func delete(setting: Setting) {
        dataStore.delete(setting: setting)
    }
    
}

