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
        case .natural: return L10n.natural
        case .pop: return L10n.pop
        case .elegant: return L10n.elegant
        case .season: return L10n.season
        case .japan: return L10n.japan
        case .overseas: return L10n.overseas
        case .service: return L10n.service
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
