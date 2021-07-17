//
//  SeasonConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum SeasonConcept: CaseIterable {
    case spring
    case summer
    case autumn
    case winter
}

extension SeasonConcept {
    
    var title: String {
        switch self {
            case .spring: return "春"
            case .summer: return "夏"
            case .autumn: return "秋"
            case .winter: return "冬"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .spring:
                return [.Spring.femininePink,
                        .Spring.springPink,
                        .Spring.newColorPink]
            case .summer:
                return [.Summer.puddingYellow,
                        .Summer.romanianBlue,
                        .Summer.summerSky]
            case .autumn:
                return [.Autumn.hiirotakeOrange,
                        .Autumn.richMilk,
                        .Autumn.safariSandwich]
            case .winter:
                return [.Winter.chillyRain,
                        .Winter.thousandBlue,
                        .Winter.betterGray]
        }
    }
    
}

private extension UIColor {
    
    struct Spring {
        static let femininePink = UIColor(hex: "fcebef")
        static let springPink = UIColor(hex: "f6c0d1")
        static let newColorPink = UIColor(hex: "ef8893")
    }
    struct Summer {
        static let puddingYellow = UIColor(hex: "fdd000")
        static let romanianBlue = UIColor(hex: "0068b7")
        static let summerSky = UIColor(hex: "9fd9f6")
    }
    struct Autumn {
        static let hiirotakeOrange = UIColor(hex: "f0831e")
        static let richMilk = UIColor(hex: "feebbe")
        static let safariSandwich = UIColor(hex: "bc6e2e")
    }
    struct Winter {
        static let chillyRain = UIColor(hex: "4f85a6")
        static let thousandBlue = UIColor(hex: "79a7d9")
        static let betterGray = UIColor(hex: "d8dbd9")
    }
    
}
