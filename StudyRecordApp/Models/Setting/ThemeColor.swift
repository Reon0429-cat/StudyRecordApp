//
//  ThemeColor.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

enum ThemeColorType {
    case main
    case sub
    case accent
    var key: String {
        switch self {
            case .main: return "mainKey"
            case .sub: return "subKey"
            case .accent: return "accentKey"
        }
    }
}

struct ThemeColor {
    static var main: UIColor {
        return UserDefaults.standard.loadColor(.main) ?? .white
    }
    static var sub: UIColor {
        return UserDefaults.standard.loadColor(.sub) ?? .white
    }
    static var accent: UIColor {
        return UserDefaults.standard.loadColor(.accent) ?? .white
    }
}

extension UserDefaults {
     
    func loadColor(_ themeColorType: ThemeColorType) -> UIColor? {
        guard let colorData = self.data(forKey: themeColorType.key),
              let color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
        else { return nil }
        return color
    }
    
    func save(color: UIColor?, _ themeColorType: ThemeColorType) {
        let colorData = try! NSKeyedArchiver.archivedData(withRootObject: color as Any,
                                                          requiringSecureCoding: false) as NSData?
        self.set(colorData, forKey: themeColorType.key)
    }
    
}
