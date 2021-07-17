//
//  OverseasConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum OverseasConcept: CaseIterable {
    case foreignCountries
    case journey
    case mysterious
}

extension OverseasConcept {
    
    var title: String {
        switch self {
            case .foreignCountries: return "外国"
            case .journey: return "旅行"
            case .mysterious: return "不思議"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .foreignCountries:
                return [.ForeignCountries.mildChocolate,
                        .ForeignCountries.milkTea,
                        .ForeignCountries.dolphinGray]
            case .journey:
                return [.Journey.dizzyRed,
                        .Journey.forceGreen,
                        .Journey.abricotYellow]
            case .mysterious:
                return [.Mysterious.sweetPink,
                        .Mysterious.magnoliaBlue,
                        .Mysterious.poolsideGreen]
        }
    }
    
}

private extension UIColor {
    
    struct ForeignCountries {
        static let mildChocolate = UIColor(hex: "aa998a")
        static let milkTea = UIColor(hex: "eadfca")
        static let dolphinGray = UIColor(hex: "9ec3bc")
    }
    struct Journey {
        static let dizzyRed = UIColor(hex: "9f002d")
        static let forceGreen = UIColor(hex: "0d955a")
        static let abricotYellow = UIColor(hex: "e7a100")
    }
    struct Mysterious {
        static let sweetPink = UIColor(hex: "f5d8cc")
        static let magnoliaBlue = UIColor(hex: "2e69b3")
        static let poolsideGreen = UIColor(hex: "4abcb9")
    }
    
}


