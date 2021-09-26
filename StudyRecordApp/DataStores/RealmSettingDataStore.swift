//
//  RealmSettingDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

protocol SettingDataStoreProtocol {
    func create(setting: Setting)
    func readAll() -> [Setting]
    func update(setting: Setting)
    func delete(setting: Setting)
}

final class RealmSettingDataStore: SettingDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<SettingRealm> {
        realm.objects(SettingRealm.self)
    }
    
    func create(setting: Setting) {
        let settingRealm = SettingRealm(setting: setting)
        try! realm.write {
            realm.add(settingRealm)
        }
    }
    
    func readAll() -> [Setting] {
        return objects.map { Setting(setting: $0) }
    }
    
    func update(setting: Setting) {
        let object = realm.object(ofType: SettingRealm.self,
                                  forPrimaryKey: setting.identifier) ?? SettingRealm()
        let setting = Setting(isDarkMode: setting.isDarkMode,
                              darkModeSettingType: setting.darkModeSettingType,
                              isPasscodeSetted: setting.isPasscodeSetted,
                              passcode: setting.passcode,
                              isPushNotificationSetted: setting.isPushNotificationSetted,
                              language: setting.language,
                              identifier: setting.identifier)
        try! realm.write {
            object.isDarkMode = setting.isDarkMode
            object.darkModeSettingType = setting.darkModeSettingType
            object.isPasscodeSetted = setting.isPasscodeSetted
            object.passcode = setting.passcode
            object.isPushNotificationSetted = setting.isPushNotificationSetted
            object.language = setting.language
        }
    }
    
    func delete(setting: Setting) {
        let object = realm.object(ofType: SettingRealm.self,
                                  forPrimaryKey: setting.identifier) ?? SettingRealm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

private extension SettingRealm {
    
    convenience init(setting: Setting) {
        self.init()
        let setting = Setting(isDarkMode: setting.isDarkMode,
                              darkModeSettingType: setting.darkModeSettingType,
                              isPasscodeSetted: setting.isPasscodeSetted,
                              passcode: setting.passcode,
                              isPushNotificationSetted: setting.isPushNotificationSetted,
                              language: setting.language,
                              identifier: setting.identifier)
        self.darkModeSettingType = setting.darkModeSettingType
        self.isPasscodeSetted = setting.isPasscodeSetted
        self.passcode = setting.passcode
        self.isPushNotificationSetted = setting.isPushNotificationSetted
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
                  isPushNotificationSetted: setting.isPushNotificationSetted,
                  language: setting.language,
                  identifier: setting.identifier)
    }
    
}
