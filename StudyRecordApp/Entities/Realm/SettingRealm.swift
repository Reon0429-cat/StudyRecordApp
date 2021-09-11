//
//  SettingRealm.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import RealmSwift

// Realmに依存した型
final class SettingRealm: Object {
    @objc dynamic var isDarkMode: Bool = false
    @objc dynamic var isPasscodeSetted: Bool = false
    @objc dynamic var isPushNotificationSetted: Bool = true
    @objc private dynamic var languageRawValue = 0
    var language: Language {
        get {
            return Language(rawValue: languageRawValue) ?? .japanese
        }
        set {
            languageRawValue = newValue.rawValue
        }
    }
}
