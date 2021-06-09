//
//  TimeManager.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/10.
//

import Foundation

struct TimeManager {
    func current() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.string(from: Date())
    }
}
