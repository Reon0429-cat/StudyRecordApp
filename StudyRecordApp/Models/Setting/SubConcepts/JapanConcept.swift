//
//  JapanConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/07/02.
//

import UIKit

enum JapanConcept: CaseIterable {
    case beautiful
    case tradition
    case moist
}

extension JapanConcept {
    
    var title: String {
        switch self {
            case .beautiful: return "華やか"
            case .tradition: return "伝統"
            case .moist: return "しっとり"
        }
    }
    var colors: [UIColor] {
        switch self {
            case .beautiful:
                return [.Beautiful.iceIvory,
                        .Beautiful.uiroPink,
                        .Beautiful.japanTea]
            case .tradition:
                return [.Tradition.burnRed,
                        .Tradition.shogunWhite,
                        .Tradition.kojiYellow]
            case .moist:
                return [.Moist.classicBeige,
                        .Moist.emperorGreen,
                        .Moist.signoraRed]
        }
    }
    
}

private extension UIColor {
    
    struct Beautiful {
        static let iceIvory = UIColor(hex: "f3deb9")
        static let uiroPink = UIColor(hex: "e8aaa3")
        static let japanTea = UIColor(hex: "aeac78")
    }
    struct Tradition {
        static let burnRed = UIColor(hex: "e02613")
        static let shogunWhite = UIColor(hex: "f7f3e9")
        static let kojiYellow = UIColor(hex: "deb253")
    }
    struct Moist {
        static let classicBeige = UIColor(hex: "e6dfcb")
        static let emperorGreen = UIColor(hex: "567947")
        static let signoraRed = UIColor(hex: "eb5a09")
    }
    
}
