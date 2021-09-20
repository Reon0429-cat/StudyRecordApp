//
//  Converter.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/11.
//

import UIKit

struct Converter {
    
    static func convertToString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .full
        let localeIdentifier = Bundle.main.preferredLocalizations.first!
        let locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM",
                                                        options: 0,
                                                        locale: locale)
        return formatter.string(from: date)
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
