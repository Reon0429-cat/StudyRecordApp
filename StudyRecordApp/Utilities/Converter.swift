//
//  Converter.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/11.
//

import UIKit

struct Converter {
    
    static func convertToString(from date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func convertToDate(from string: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func convertToImage(from data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return nil
    }
    
    static func convertToData(from image: UIImage?) -> Data? {
        if let image = image {
            return image.jpegData(compressionQuality: 1)
        }
        return nil
    }
    
}
