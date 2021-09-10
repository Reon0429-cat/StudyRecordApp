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
    
}
