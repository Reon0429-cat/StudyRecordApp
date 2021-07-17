//
//  ElegantConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum ElegantConcept: CaseIterable {
    case adultColor
    case gorgeous
    case art
    case intelligence
}

extension ElegantConcept {
    
    var title: String {
        switch self {
            case .adultColor: return "アダルトカラー"
            case .gorgeous: return "ゴージャス"
            case .art: return "アート"
            case .intelligence: return "インテリジェンス"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .adultColor:
                return [.AdultColor.queenCharcoal,
                        .AdultColor.fireSalamander,
                        .AdultColor.concreteGray]
            case .gorgeous:
                return [.Gorgeous.parisGold,
                        .Gorgeous.lakebottom,
                        .Gorgeous.rembrandtMader]
            case .art:
                return [.Art.spaceBlue,
                        .Art.mondrianRed,
                        .Art.rikiYellow]
            case .intelligence:
                return [.Intelligence.gentryBlue,
                        .Intelligence.pipeBlue,
                        .Intelligence.gentryBlue]
        }
    }
    
}

private extension UIColor {
    
    struct AdultColor {
        static let queenCharcoal = UIColor(hex: "494544")
        static let fireSalamander = UIColor(hex: "c41a30")
        static let concreteGray = UIColor(hex: "bac8c6")
    }
    struct Gorgeous {
        static let parisGold = UIColor(hex: "d4b572")
        static let lakebottom = UIColor(hex: "003740")
        static let rembrandtMader = UIColor(hex: "b15a5e")
    }
    struct Art {
        static let spaceBlue = UIColor(hex: "303967")
        static let mondrianRed = UIColor(hex: "e60012")
        static let rikiYellow = UIColor(hex: "ffe200")
    }
    struct Intelligence {
        static let gentryBlue = UIColor(hex: "34485e")
        static let pipeBlue = UIColor(hex: "3c7d9b")
        static let greenGarnet = UIColor(hex: "5b9f8a")
    }
    
}
