//
//  UIColor+Extension.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

extension UIColor {
    
    // hex(16進数) -> rgb
    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // 0 〜　255で入力可能
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        let rgb = [red, green, blue].map { value -> CGFloat in
            if value < 0 { return 0 }
            if value > 255 { return 1 }
            return value / 255
        }
        let alpha: CGFloat = {
            if alpha > 100 { return 1 }
            if alpha < 0 { return 0 }
            return CGFloat(alpha) / 100
        }()
        return self.init(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: alpha)
    }
    
    // UIColor -> それぞれのrgb値
    var redValue: CGFloat {
        return getRed().red
    }
    
    var greenValue: CGFloat {
        return getRed().green
    }
    
    var blueValue: CGFloat {
        return getRed().blue
    }
    
    var alphaValue: CGFloat {
        return getRed().alpha
    }
    
    private func getRed() -> (red: CGFloat,
                              green: CGFloat,
                              blue: CGFloat,
                              alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
