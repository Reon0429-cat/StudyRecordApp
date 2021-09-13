//
//  ColorConcept.swift
//  ThemeColor-Sample
//
//  Created by 大西玲音 on 2021/06/28.
//

import UIKit

enum ColorConcept: CaseIterable {
    case natural
    case pop
    case elegant
    case season
    case japan
    case overseas
    case service
    
    var title: String {
        switch self {
            case .natural:
                return LocalizeKey.natural.localizedString()
            case .pop:
                return LocalizeKey.pop.localizedString()
            case .elegant:
                return LocalizeKey.elegant.localizedString()
            case .season:
                return LocalizeKey.season.localizedString()
            case .japan:
                return LocalizeKey.japan.localizedString()
            case .overseas:
                return LocalizeKey.overseas.localizedString()
            case .service:
                return LocalizeKey.service.localizedString()
        }
    }
    var subConceptTitles: [String] {
        switch self {
            case .natural: return NaturalConcept.allCases.map { $0.title }
            case .pop: return PopConcept.allCases.map { $0.title }
            case .elegant: return ElegantConcept.allCases.map { $0.title }
            case .season: return SeasonConcept.allCases.map { $0.title }
            case .japan: return JapanConcept.allCases.map { $0.title }
            case .overseas: return OverseasConcept.allCases.map { $0.title }
            case .service: return ServiceConcept.allCases.map { $0.title }
        }
    }
    var colors: [[UIColor]] {
        switch self {
            case .natural: return NaturalConcept.allCases.map { $0.colors }
            case .pop: return PopConcept.allCases.map { $0.colors }
            case .elegant: return ElegantConcept.allCases.map { $0.colors }
            case .season: return SeasonConcept.allCases.map { $0.colors }
            case .japan: return JapanConcept.allCases.map { $0.colors }
            case .overseas: return OverseasConcept.allCases.map { $0.colors }
            case .service: return ServiceConcept.allCases.map { $0.colors }
        }
    }
}
