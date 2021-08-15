//
//  Convert.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/11.
//

import Foundation

struct Convert {
    
    func stringFrom(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
}
