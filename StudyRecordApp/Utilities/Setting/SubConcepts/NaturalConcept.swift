//
//  NaturalConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum NaturalConcept: CaseIterable {
    case relax
    case feminine
    case organic
    case craft
    case living
    case botanical
}

extension NaturalConcept {
    
    var title: String {
        switch self {
            case .relax: return "リラックス"
            case .feminine: return "フェミニン"
            case .organic: return "オーガニック"
            case .craft: return "クラフト"
            case .living: return "リビング"
            case .botanical: return "ボタニカル"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .relax:
                return [.Relax.eggIvory,
                        .Relax.softBuff,
                        .Relax.mistMossGreen]
            case .feminine:
                return [.Feminine.grandmaPink,
                        .Feminine.blueVanilla,
                        .Feminine.grandmaPurple]
            case .organic:
                return [.Organic.pattyGray,
                        .Organic.classicPink,
                        .Organic.smoothGreen]
            case .craft:
                return [.Craft.twilightGray,
                        .Craft.sharpGray,
                        .Craft.japaneseKai]
            case .living:
                return [.Living.creamBlue,
                        .Living.northOcean,
                        .Living.shineMuscat]
            case .botanical:
                return [.Botanical.clearWater,
                        .Botanical.fineweed,
                        .Botanical.babyLeaf]
        }
    }
    
}

private extension UIColor {
    
    struct Relax {
        static let eggIvory = UIColor(hex: "f3eed5")
        static let softBuff = UIColor(hex: "e4af9b")
        static let mistMossGreen = UIColor(hex: "d4dfbb")
    }
    struct Feminine {
        static let grandmaPink = UIColor(hex: "e6c5cf")
        static let blueVanilla = UIColor(hex: "bdd8dd")
        static let grandmaPurple = UIColor(hex: "af9dc0")
    }
    struct Organic {
        static let pattyGray = UIColor(hex: "d9d8ce")
        static let classicPink = UIColor(hex: "e0b6a9")
        static let smoothGreen = UIColor(hex: "d3e9d0")
    }
    struct Craft {
        static let twilightGray = UIColor(hex: "dcd5c8")
        static let sharpGray = UIColor(hex: "a2a2ad")
        static let japaneseKai = UIColor(hex: "1f1e63")
    }
    struct Living {
        static let creamBlue = UIColor(hex: "e0f1f1")
        static let northOcean = UIColor(hex: "5188b1")
        static let shineMuscat = UIColor(hex: "aed265")
    }
    struct Botanical {
        static let clearWater = UIColor(hex: "d9eaec")
        static let fineweed = UIColor(hex: "74a64c")
        static let babyLeaf = UIColor(hex: "bcd537")
    }
    
}
