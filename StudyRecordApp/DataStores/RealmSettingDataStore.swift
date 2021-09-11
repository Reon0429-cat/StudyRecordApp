//
//  RealmSettingDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

protocol SettingDataStoreProtocol {
    func create(setting: Setting)
    func read(at index: Int) -> Setting
    func readAll() -> [Setting]
    func update(setting: Setting, at index: Int)
    func delete(at index: Int)
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
    
    func read(at index: Int) -> Setting {
        return Setting(setting: objects[index])
    }
    
    func readAll() -> [Setting] {
        return objects.map { Setting(setting: $0) }
    }
    
    func update(setting: Setting, at index: Int) {
        let object = objects[index]
        let setting = Setting(isDarkMode: setting.isDarkMode,
                              isPasscodeSetted: setting.isPasscodeSetted,
                              isPushNotificationSetted: setting.isPushNotificationSetted,
                              language: setting.language)
        try! realm.write {
            object.isDarkMode = setting.isDarkMode
            object.isPasscodeSetted = setting.isPasscodeSetted
            object.isPushNotificationSetted = setting.isPushNotificationSetted
            object.language = setting.language
        }
    }
    
    func delete(at index: Int) {
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

private extension SettingRealm {
    
    convenience init(setting: Setting) {
        self.init()
        let setting = Setting(isDarkMode: setting.isDarkMode,
                              isPasscodeSetted: setting.isPasscodeSetted,
                              isPushNotificationSetted: setting.isPushNotificationSetted,
                              language: setting.language)
        self.isDarkMode = setting.isDarkMode
        self.isPasscodeSetted = setting.isPasscodeSetted
        self.isPushNotificationSetted = setting.isPushNotificationSetted
        self.language = setting.language
    }
    
}

private extension Setting {
    
    init(setting: SettingRealm) {
        self.init(isDarkMode: setting.isDarkMode,
                  isPasscodeSetted: setting.isPasscodeSetted,
                  isPushNotificationSetted: setting.isPushNotificationSetted,
                  language: setting.language)
    }
    
}
