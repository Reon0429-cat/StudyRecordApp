//
//  DateType.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/21.
//

import UIKit

enum DateType: Int, CaseIterable {
    case year
    case month
    case day
    case hour
    case minutes

    var component: Int {
        self.rawValue
    }

    var numbers: [Int] {
        switch self {
        case .year: return [Int](2020 ... 2025)
        case .month: return [Int](1 ... 12)
        case .day: return [Int](1 ... 31)
        case .hour: return [Int](0 ... 23)
        case .minutes: return [Int](0 ... 59)
        }
    }

    func title(row: Int) -> String {
        switch self {
        case .year:
            switch Locale.language {
            case .ja: return "\(self.numbers[row])" + L10n.year
            case .en: return "\(self.numbers[row])"
            }
        case .month:
            switch Locale.language {
            case .ja: return "\(self.numbers[row])" + L10n.month
            case .en: return "\(Month(rawValue: row)!.text.prefix(3))"
            }
        case .day:
            switch Locale.language {
            case .ja: return "\(self.numbers[row])" + L10n.day
            case .en: return "\(self.numbers[row])"
            }
        case .hour: return "\(self.numbers[row])" + L10n.shortHour
        case .minutes: return "\(self.numbers[row])" + L10n.shortMinute
        }
    }

    var alignment: NSTextAlignment {
        switch self {
        case .year: return .right
        case .month: return .center
        case .day: return .left
        case .hour: return .center
        case .minutes: return .left
        }
    }
}
