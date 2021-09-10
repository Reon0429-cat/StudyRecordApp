//
//  ScreenType.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/17.
//

import Foundation

protocol ScreenPresentationDelegate: AnyObject {
    func screenDidPresented(screenType: ScreenType)
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
            case .record: return "記録"
            case .graph: return "グラフ"
            case .goal: return "目標"
            case .setting: return "設定"
        }
    }
}
