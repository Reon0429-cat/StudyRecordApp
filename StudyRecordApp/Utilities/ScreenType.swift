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
                return LocalizeKey.record.localizedString()
            case .graph:
                return LocalizeKey.graph.localizedString()
            case .goal:
                return LocalizeKey.goal.localizedString()
            case .setting:
                return LocalizeKey.setting.localizedString()
        }
    }
}
