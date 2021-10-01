//
//  SettingUseCase.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import Foundation
import CryptoKit

final class SettingUseCase {
    
    private let repository: SettingRepositoryProtocol
    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
    }
    
    var setting: Setting {
        if repository.readAll().isEmpty {
            let setting = Setting(isDarkMode: false,
                                  darkModeSettingType: .app,
                                  isPasscodeSetted: false,
                                  passcode: "",
                                  isBiometricsSetted: false,
                                  language: .japanese,
                                  identifier: UUID().uuidString)
            repository.create(setting: setting)
            return setting
        }
        return repository.read(at: 0)
    }
    
    func update(setting: Setting) {
        repository.update(setting: setting)
    }
    
    func change(isDarkMode: Bool) {
        let newSetting = Setting(isDarkMode: isDarkMode,
                                 darkModeSettingType: setting.darkModeSettingType,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 passcode: setting.passcode,
                                 isBiometricsSetted: setting.isBiometricsSetted,
                                 language: setting.language,
                                 identifier: setting.identifier)
        repository.update(setting: newSetting)
    }
    
    func change(darkModeSettingType: DarkModeSettingType) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 darkModeSettingType: darkModeSettingType,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 passcode: setting.passcode,
                                 isBiometricsSetted: setting.isBiometricsSetted,
                                 language: setting.language,
                                 identifier: setting.identifier)
        repository.update(setting: newSetting)
    }
    
    func change(isPasscodeSetted: Bool) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 darkModeSettingType: setting.darkModeSettingType,
                                 isPasscodeSetted: isPasscodeSetted,
                                 passcode: setting.passcode,
                                 isBiometricsSetted: setting.isBiometricsSetted,
                                 language: setting.language,
                                 identifier: setting.identifier)
        repository.update(setting: newSetting)
    }
    
    var isPasscodeCreated: Bool {
        return !setting.passcode.isEmpty
    }
    
    func isSame(passcode: String) -> Bool {
        return setting.passcode == passcode.toHash()
    }
    
    func create(passcode: String) {
        updatePasscode(passcode: passcode)
    }
    
    func update(passcode: String) {
        updatePasscode(passcode: passcode)
    }
    
    func update(isBiometricsSetted: Bool) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 darkModeSettingType: setting.darkModeSettingType,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 passcode: setting.passcode,
                                 isBiometricsSetted: isBiometricsSetted,
                                 language: setting.language,
                                 identifier: setting.identifier)
        repository.update(setting: newSetting)
    }
    
    private func updatePasscode(passcode: String) {
        let newSetting = Setting(isDarkMode: setting.isDarkMode,
                                 darkModeSettingType: setting.darkModeSettingType,
                                 isPasscodeSetted: setting.isPasscodeSetted,
                                 passcode: passcode.toHash(),
                                 isBiometricsSetted: setting.isBiometricsSetted,
                                 language: setting.language,
                                 identifier: setting.identifier)
        repository.update(setting: newSetting)
    }
    
}

private extension String {
    
    func toHash() -> String {
        let data = self.data(using: .utf8)!
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
}
