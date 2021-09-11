//
//  SettingUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import Foundation

final class SettingUseCase {
    
    private let repository: SettingRepositoryProtocol
    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
    }
    
    var setting: Setting {
        if repository.readAll().isEmpty {
            let setting = Setting(isDarkMode: false,
                                  isPasscodeSetted: false,
                                  isPushNotificationSetted: true,
                                  language: .japanese)
            repository.create(setting: setting)
            return setting
        }
        return repository.read(at: 0)
    }
    
    func update(setting: Setting) {
        repository.update(setting: setting, at: 0)
    }
    
    func change(isDarkMode: Bool) {
        let newSetting = Setting(isDarkMode: isDarkMode,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 isPushNotificationSetted: setting.isPushNotificationSetted,
                                 language: setting.language)
        repository.update(setting: newSetting, at: 0)
    }
    
    func change(isPasscodeSetted: Bool) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 isPasscodeSetted: isPasscodeSetted,
                                 isPushNotificationSetted: setting.isPushNotificationSetted,
                                 language: setting.language)
        repository.update(setting: newSetting, at: 0)
    }
    
    func change(isPushNotificationSetted: Bool) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 isPushNotificationSetted: isPushNotificationSetted,
                                 language: setting.language)
        repository.update(setting: newSetting, at: 0)
    }
    
    func change(language: Language) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 isPushNotificationSetted: setting.isPushNotificationSetted,
                                 language: language)
        repository.update(setting: newSetting, at: 0)
    }
    
}
