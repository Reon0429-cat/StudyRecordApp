//
//  Month.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/06.
//

import Foundation

enum Month: Int {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december

    var text: String {
        switch self {
        case .january:
            return L10n.january
        case .february:
            return L10n.february
        case .march:
            return L10n.march
        case .april:
            return L10n.april
        case .may:
            return L10n.may
        case .june:
            return L10n.june
        case .july:
            return L10n.july
        case .august:
            return L10n.august
        case .september:
            return L10n.september
        case .october:
            return L10n.october
        case .november:
            return L10n.november
        case .december:
            return L10n.december
        }
    }
}
