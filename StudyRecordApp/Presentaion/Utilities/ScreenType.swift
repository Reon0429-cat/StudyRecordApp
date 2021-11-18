//
//  ScreenType.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import Foundation

protocol ScreenPresentationDelegate: AnyObject {
    func screenDidPresented(screenType: ScreenType,
                            isEnabledNavigationButton: Bool)
    func scroll(sourceScreenType: ScreenType,
                destinationScreenType: ScreenType,
                completion: (() -> Void)?)
}

enum ScreenType: Int, CaseIterable {
    case record
    case graph
    case goal
    case setting

    var title: String {
        switch self {
        case .record:
            return L10n.record
        case .graph:
            return L10n.graph
        case .goal:
            return L10n.goal
        case .setting:
            return L10n.setting
        }
    }
}
