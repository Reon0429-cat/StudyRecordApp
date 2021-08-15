//
//  PopConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum PopConcept: CaseIterable {
    case colorful
    case retro
    case kids
    case girly
    case active
    case catchu
    case happy
}

extension PopConcept {
    
    var title: String {
        switch self {
            case .colorful: return "カラフル"
            case .retro: return "レトロ"
            case .kids: return "キッズ"
            case .girly: return "ガーリー"
            case .active: return "アクティブ"
            case .catchu: return "キャッチュ"
            case .happy: return "ハッピー"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .colorful:
                return [.Colorful.tangoRed,
                        .Colorful.mxicanPurple,
                        .Colorful.mexicanPink]
            case .retro:
                return [.Retro.mattIvory,
                        .Retro.familyRed,
                        .Retro.retroGreen]
            case .kids:
                return [.Kids.recitalOrange,
                        .Kids.dummyGreen,
                        .Kids.gauguinRed]
            case .girly:
                return [.Girly.softShellPink,
                        .Girly.paleMint,
                        .Girly.irisMagic]
            case .active:
                return [.Active.aquaMermaid,
                        .Active.vividGrape,
                        .Active.ladiesPink]
            case .catchu:
                return [.Catchu.dandelion,
                        .Catchu.habaneroRed,
                        .Catchu.harmonyGreen]
            case .happy:
                return [.Happy.cantaloupe,
                        .Happy.macaronPink,
                        .Happy.babyBlue]
        }
    }
    
}

private extension UIColor {
    
    struct Colorful {
        static let tangoRed = UIColor(hex: "d80c18")
        static let mxicanPurple = UIColor(hex: "a660a3")
        static let mexicanPink = UIColor(hex: "ea6096")
    }
    struct Retro {
        static let mattIvory = UIColor(hex: "ebd880")
        static let familyRed = UIColor(hex: "c03619")
        static let retroGreen = UIColor(hex: "00979b")
    }
    struct Kids {
        static let recitalOrange = UIColor(hex: "f08437")
        static let dummyGreen = UIColor(hex: "00a040")
        static let gauguinRed = UIColor(hex: "e6191c")
    }
    struct Girly {
        static let softShellPink = UIColor(hex: "f8ccd1")
        static let paleMint = UIColor(hex: "c2e2d2")
        static let irisMagic = UIColor(hex: "c9c2e0")
    }
    struct Active {
        static let aquaMermaid = UIColor(hex: "64c0ab")
        static let vividGrape = UIColor(hex: "4d4398")
        static let ladiesPink = UIColor(hex: "e85298")
    }
    struct Catchu {
        static let dandelion = UIColor(hex: "ffeb27")
        static let habaneroRed = UIColor(hex: "e8382f")
        static let harmonyGreen = UIColor(hex: "13ae67")
    }
    struct Happy {
        static let cantaloupe = UIColor(hex: "faca7b")
        static let macaronPink = UIColor(hex: "f096a0")
        static let babyBlue = UIColor(hex: "e0f1f4")
    }
    
}

