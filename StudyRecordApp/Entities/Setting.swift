//
//  Setting.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/10.
//

import Foundation

// 共通の型
struct Setting {
    let isDarkMode: Bool
    let isPasscodeSetted: Bool
    let passcode: String
    let isPushNotificationSetted: Bool
    let language: Language
}

enum Language: Int {
    case japanese
    case english
}
