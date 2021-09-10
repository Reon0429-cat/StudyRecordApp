//
//  Setting.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/10.
//

import Foundation

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
