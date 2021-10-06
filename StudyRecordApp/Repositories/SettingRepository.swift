//
//  SettingRepository.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import Foundation
import RealmSwift

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
        let settingRealm = SettingRealm(setting: setting)
        dataStore.create(setting: settingRealm)
    }
    
    func read(at index: Int) -> Setting {
        let setting = Setting(setting: dataStore.readAll()[index])
        return setting
    }
    
    func readAll() -> [Setting] {
        let settings = dataStore.readAll().map { Setting(setting: $0) }
        return settings
    }
    
    func update(setting: Setting) {
        let settingRealm = SettingRealm(setting: setting)
        dataStore.update(setting: settingRealm)
    }
    
    func delete(setting: Setting) {
        let settingRealm = SettingRealm(setting: setting)
        dataStore.delete(setting: settingRealm)
    }
    
}

private extension SettingRealm {
    
    convenience init(setting: Setting) {
        self.init()
        let setting = Setting(isDarkMode: setting.isDarkMode,
                              darkModeSettingType: setting.darkModeSettingType,
                              isPasscodeSetted: setting.isPasscodeSetted,
                              passcode: setting.passcode,
                              isBiometricsSetted: setting.isBiometricsSetted,
                              language: setting.language,
                              identifier: setting.identifier)
        self.darkModeSettingType = setting.darkModeSettingType
        self.isPasscodeSetted = setting.isPasscodeSetted
        self.passcode = setting.passcode
        self.isBiometricsSetted = setting.isBiometricsSetted
        self.language = setting.language
        self.identifier = setting.identifier
    }
    
}

private extension Setting {
    
    init(setting: SettingRealm) {
        self.init(isDarkMode: setting.isDarkMode,
                  darkModeSettingType: setting.darkModeSettingType,
                  isPasscodeSetted: setting.isPasscodeSetted,
                  passcode: setting.passcode,
                  isBiometricsSetted: setting.isBiometricsSetted,
                  language: setting.language,
                  identifier: setting.identifier)
    }
    
}
