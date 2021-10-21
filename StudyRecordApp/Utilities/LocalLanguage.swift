//
//  String+Extension.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/22.
//

import Foundation

enum LocalLanguage: String {
    case ja
    case en
}

extension Locale {
    
    static var language: LocalLanguage {
        let languageCode = Locale.current.languageCode ?? ""
        return LocalLanguage(rawValue: languageCode) ?? .ja
    }
    
}
