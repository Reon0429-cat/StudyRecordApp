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
    let darkModeSettingType: DarkModeSettingType
    let isPasscodeSetted: Bool
    let passcode: String
    let isBiometricsSetted: Bool
    let language: Language
    let identifier: String
}

enum DarkModeSettingType: Int {
    case app
    case auto
}

enum Language: Int {
    case japanese
    case english
}
