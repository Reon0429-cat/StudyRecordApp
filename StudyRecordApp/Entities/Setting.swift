//
//  Setting.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/10.
//

import RealmSwift

// 共通の型
struct Setting {
    var isDarkMode: Bool
    var isPasscodeSetted: Bool
    var isPushNotificationSetted: Bool
    var language: Language
}

enum Language: Int {
    case japanese
    case english
}

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
