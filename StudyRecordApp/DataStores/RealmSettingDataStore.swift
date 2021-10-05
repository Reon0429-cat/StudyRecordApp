//
//  RealmSettingDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

protocol SettingDataStoreProtocol {
    func create(setting: SettingRealm)
    func readAll() -> [SettingRealm]
    func update(setting: SettingRealm)
    func delete(setting: SettingRealm)
}

final class RealmSettingDataStore: SettingDataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<SettingRealm> {
        realm.objects(SettingRealm.self)
    }
    
    func create(setting: SettingRealm) {
        try! realm.write {
            realm.add(setting)
        }
    }
    
    func readAll() -> [SettingRealm] {
        return objects.map { $0 }
    }
    
    func update(setting: SettingRealm) {
        let object = realm.object(ofType: SettingRealm.self,
                                  forPrimaryKey: setting.identifier) ?? SettingRealm()
        try! realm.write {
            object.isDarkMode = setting.isDarkMode
            object.darkModeSettingType = setting.darkModeSettingType
            object.isPasscodeSetted = setting.isPasscodeSetted
            object.passcode = setting.passcode
            object.isBiometricsSetted = setting.isBiometricsSetted
            object.language = setting.language
        }
    }
    
    func delete(setting: SettingRealm) {
        let object = realm.object(ofType: SettingRealm.self,
                                  forPrimaryKey: setting.identifier) ?? SettingRealm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
}

