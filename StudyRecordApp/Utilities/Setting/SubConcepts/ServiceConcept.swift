//
//  ServiceConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/03.
//

import UIKit

enum ServiceConcept: CaseIterable {
    case business
    case digital
    case shop
}

extension ServiceConcept {
    
    var title: String {
        switch self {
            case .business: return "ビジネス"
            case .digital: return "デジタル"
            case .shop: return "ショップ"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .business:
                return [.Business.armyBlue,
                        .Business.coolishBlue,
                        .Business.maldivesBlue]
            case .digital:
                return [.Digital.orientBlack,
                        .Digital.toyYellow,
                        .Digital.pairGreen]
            case .shop:
                return [.Shop.mochaDog,
                        .Shop.belgiumWall,
                        .Shop.riverside]
        }
    }
    
}

private extension UIColor {
    
    struct Business {
        static let armyBlue = UIColor(hex: "101841")
        static let coolishBlue = UIColor(hex: "70acce")
        static let maldivesBlue = UIColor(hex: "144da0")
    }
    struct Digital {
        static let orientBlack = UIColor(hex: "1e1210")
        static let toyYellow = UIColor(hex: "ffe200")
        static let pairGreen = UIColor(hex: "c3d82d")
    }
    struct Shop {
        static let mochaDog = UIColor(hex: "a2997f")
        static let belgiumWall = UIColor(hex: "6e6457")
        static let riverside = UIColor(hex: "cfdedf")
    }
    
}
