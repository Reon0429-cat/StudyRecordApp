//
//  RealmSettingDataStore.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import Foundation

final class RealmSettingDataStore {

    func create(setting: SettingRealm) {
        RealmManager().create(object: setting)
    }

    func readAll() -> [SettingRealm] {
        return RealmManager().readAll(type: SettingRealm.self,
                                      byKeyPath: nil)
    }

    func update(setting: SettingRealm) {
        RealmManager().update(object: setting)
    }

    func delete(setting: SettingRealm) {
        RealmManager().delete(object: setting)
    }

}
